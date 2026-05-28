{
  config,
  pkgs,
  lib,
  utils,
  ...
}:

let
  cfg = config.virtualisation.fex;

  common = {
    # Settings taken from the files in `lib/binfmt.d` of the `fex` package
    preserveArgvZero = true;
    openBinary = true;
    matchCredentials = true;
    fixBinary = true;
    offset = 0;
    interpreter = lib.getExe' cfg.package "FEXInterpreter";
    wrapInterpreterInShell = false;
  };

  # Discard string context to avoid pulling in each guest library as a
  # dependency of the system.
  mkLibPath' = drv: builtins.unsafeDiscardStringContext (mkLibPath drv);
  mkLibPath = drv: "${lib.getLib drv}/lib";

  wrapThunk =
    {
      name,
      rpath,
    }:
    pkgs.runCommandLocal "fex-host-thunk-${name}"
      {
        buildInputs = [ pkgs.patchelf ];

        thunkName = "${name}-host.so";
        thunkPath = "lib/fex-emu/HostThunks";
      }
      ''
        doPatch() {
          mkdir -p "$(dirname "$out/$1")"
          patchelf "$1" --output "$out/$1" --add-rpath "${rpath}"
        }

        echo "wrapping thunk '${name}'..."
        pushd "${cfg.package}"

        doPatch "$thunkPath/$thunkName"

        if [ -f "''${thunkPath}_32/$thunkName" ]; then
          doPatch "''${thunkPath}_32/$thunkName"
        fi
      '';

  forwardedLibrarySubmodule = lib.types.submodule (
    { name, config, ... }:
    {
      options = {
        # TODO: reading back the option names/descriptions, literally *none* of
        # them make sense, they should all be rewritten

        enable = lib.mkEnableOption "forwarding this library" // {
          default = true;
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          defaultText = "‹name›";
          description = ''
            The thunk name of the library to be forwarded.
            The value "{option}`name`-host.so" will be used as the host thunk
            name, and "{option}`name`-guest.so" as the guest thunk name.
          '';
        };

        packages = lib.mkOption {
          type = lib.types.functionTo (lib.types.listOf lib.types.package);
          default = pkgs: [ pkgs.${config.name} ];
          defaultText = lib.literalExpression "pkgs: [ pkgs.‹name› ]";
          description = ''
            Packages to add to both {option}`hostPackages` and
            {option}`guestPackages`.
          '';
        };

        hostPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = ''
            The list of host packages that contain this library. These packages
            will be built, and their library paths (suffixed with `/lib`) will be
            added as RPATHs to the host thunk.
          '';
        };

        extraHostPaths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Extra list of paths which will be added verbatim as RPATHs to the
            host thunk.
          '';
        };

        guestPackages = lib.mkOption {
          type = lib.types.functionTo (lib.types.listOf lib.types.package);
          default = pkgs: [ ];
          defaultText = lib.literalExpression "pkgs: [ ]";
          description = ''
            The list of guest packages that contain this library. These packages
            will not be built, but their paths (suffixed with {option}`names`)
            will be redirected at runtime to the guest thunk.
          '';
        };

        extraGuestPaths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = lib.literalExpression ''[ "@PREFIX_LIB@" ]'';
          description = ''
            Extra list of prefixes, which will be suffixed with {option}`names`
            and redirected at runtime to the guest thunk.
          '';
        };

        names = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "${name}.so" ];
          defaultText = lib.literalExpression ''[ "‹name›.so" ]'';
          description = ''
            The possible names of the object file of this library. They will be
            prefixed with {option}`extraGuestPaths` and {option}`guestPackages`,
            and the resulting paths will be redirected at runtime to the guest
            thunk.
          '';
        };

        # === private === #

        wrappedThunk = lib.mkOption {
          type = lib.types.package;
          visible = false;
          internal = true;
          readOnly = true;
          description = ''
            The wrapped host thunk for this library.
          '';
        };

        overlayPaths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          visible = false;
          internal = true;
          readOnly = true;
          description = ''
            The final list of paths to forward to the guest thunk.
          '';
        };
      };

      config =
        let
          hostPackages = config.packages pkgs ++ config.hostPackages;
          hostPaths = lib.map mkLibPath hostPackages ++ config.extraHostPaths;
          guestPackages = lib.concatMap (
            set: config.packages set ++ config.guestPackages set
          ) cfg.guestPackageSets;
          guestPaths = lib.map mkLibPath' guestPackages ++ config.extraGuestPaths;
        in
        {
          wrappedThunk = wrapThunk {
            inherit (config) name;
            rpath = lib.concatStringsSep ":" hostPaths;
          };

          overlayPaths = lib.map (x: "${x.path}/${x.name}") (
            lib.cartesianProduct {
              name = config.names;
              path = guestPaths;
            }
          );
        };
    }
  );

  wrappedHostThunks = pkgs.symlinkJoin {
    name = "fex-host-thunks";
    paths = lib.mapAttrsToList (_: library: library.wrappedThunk) cfg.forwardedLibraries;
  };

  enumSuffixes =
    base: suffixes:
    lib.map (x: x.base + x.suffix) (
      lib.cartesianProduct {
        base = [ base ];
        suffix = suffixes ++ [ "" ];
      }
    );

  # Fex's config format is not quite JSON, there are some trivial differences,
  # like they represent booleans as "1" and "0", but also, the way they
  # represent arrays is by having a repeating key multiple times... So we
  # basically build each item as JSON and then hand-roll sandwiching them
  # together.

  convertConfig =
    attrs:
    let
      /**
        Removes the first and last character of a string. So `{"key":"value"}`
        becomes `"key":"value"`
      */
      strip = str: builtins.substring 1 ((builtins.stringLength str) - 2) str;

      /**
        Builds a JSON key-value pair like `"key":"value"`
      */
      kv = key: value: strip (builtins.toJSON { ${key} = value; });

      /**
        The main conversion logic
      */
      convertValue =
        key: value:
        if builtins.isBool value then
          [ (kv key (if value then "1" else "0")) ]
        else if builtins.isInt value then
          [ (kv key (toString value)) ]
        else if builtins.isList value then
          builtins.concatMap (convertValue key) value
        else if builtins.isAttrs value then
          # Idk how they represent attrs, I don't think anything in the config uses
          # them.
          throw "Nested attribute sets are not supported for FEX settings."
        else
          [ (kv key "${value}") ];

      kvs = builtins.concatLists (lib.mapAttrsToList convertValue attrs);
    in
    "{${lib.concatStringsSep "," kvs}}";

  fexConfig =
    let
      main = pkgs.writeTextDir "Config.json" ''
        {
          "Config": ${convertConfig cfg.settings},
          "ThunksDB": ${convertConfig (lib.mapAttrs (_: library: library.enable) cfg.forwardedLibraries)}
        }
      '';
      thunksDB = pkgs.writeTextDir "ThunksDB.json" (
        builtins.toJSON {
          DB = lib.mapAttrs (_: library: {
            Library = "${library.name}-guest.so";
            Overlay = library.overlayPaths;
          }) cfg.forwardedLibraries;
        }
      );
      appConfig = pkgs.buildEnv {
        name = "fex-appconfig";
        paths = [ "${cfg.package}/share/fex-emu" ];
        pathsToLink = [ "/AppConfig" ];
      };
    in
    pkgs.symlinkJoin {
      name = "fex-config";
      paths = [
        main
        thunksDB
        appConfig
      ];
    };

  # TODO clean this up

  guestPaths32 = [
    "@PREFIX_LIB@"
    "/lib"
    "/lib32"
    "/usr/lib"
    "/usr/lib32"
    "/lib/i386-linux-gnu"
    "/usr/lib/i386-linux-gnu"
    "/usr/local/lib/i386-linux-gnu"
    "/usr/lib/pressure-vessel/overrides/lib/i386-linux-gnu"
  ];

  guestPaths64 = [
    "@PREFIX_LIB@"
    "/lib64"
    "/usr/lib64"
    "/lib/x86_64-linux-gnu"
    "/usr/lib/x86_64-linux-gnu"
    "/usr/local/lib/x86_64-linux-gnu"
    "/usr/lib/pressure-vessel/overrides/lib/x86_64-linux-gnu"
  ];
in

{
  options.virtualisation.fex = {
    enable = lib.mkEnableOption "the FEX x86 emulator";
    package = lib.mkPackageOption pkgs "fex" { };

    addToNixSandbox = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        Whether to add FEX to {option}`nix.settings.extra-platforms`. Disable
        this to use remote builders for x86 platforms, while allowing testing
        binaries locally.
      '';
    };

    guestPackageSets = lib.mkOption {
      type = lib.types.listOf lib.types.pkgs;
      default = [
        pkgs.pkgsCross.gnu32
        pkgs.pkgsCross.gnu64
      ];
      defaultText = lib.literalExpression ''
        [
          pkgs.pkgsCross.gnu32
          pkgs.pkgsCross.gnu64
        ]
      '';
      example = lib.literalExpression ''
        [
          nixpkgs.legacyPackages.i686-linux
          nixpkgs.legacyPackages.x86_64-linux
        ]
      '';
      description = ''
        The list of package sets used to retrieve library paths from on the
        guest.
      '';
    };

    forwardedLibraries = lib.mkOption {
      type = lib.types.attrsOf forwardedLibrarySubmodule;
      default = { };
      defaultText = "(all libraries supported by FEX)";
      description = "Guest libraries to forward to host-native versions.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.bool
          lib.types.str
          lib.types.int
          (lib.types.listOf (
            lib.types.oneOf [
              lib.types.bool
              lib.types.str
              lib.types.int
            ]
          ))
        ]
      );
      default = { };
      example = {
        SilentLog = false;
        OutputLog = "stderr";
      };
      description = ''
        Settings to add to the FEX configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.singleton {
      assertion = pkgs.stdenv.hostPlatform.isAarch64;
      message = "FEX emulation is only supported on aarch64.";
    };

    # TODO split lib paths in FEX package so unwrapped host thunks don't get put in path
    environment.systemPackages = [ cfg.package ];
    boot.binfmt.registrations = {
      "FEX-x86" = common // utils.binfmtMagics.i386-linux;
      "FEX-x86_64" = common // utils.binfmtMagics.x86_64-linux;
    };

    # for steam to work - the steam runtime is like a container or something
    # and has its own /etc so putting the config in /etc/fex-emu won't work
    environment.sessionVariables = {
      FEX_APP_CONFIG_LOCATION = "${fexConfig}/";
    };

    virtualisation.fex.settings = {
      ThunkHostLibs = "${wrappedHostThunks}/lib/fex-emu/HostThunks";
      ThunkGuestLibs = "${cfg.package}/share/fex-emu/GuestThunks";
    };

    # Libraries that are forwarded by default. NOTE: added libraries must have
    # a corresponding `{name}-{host,guest}.so` shared object built by FEX. The
    # below configuration encompasses all such libraries currently in FEX.
    virtualisation.fex.forwardedLibraries = {
      GL = {
        name = "libGL";
        names = enumSuffixes "libGL.so" [
          ".1"
          ".1.2.0"
          ".1.7.0"
        ];
        extraHostPaths = [ "/run/opengl-driver/lib" ];
        extraGuestPaths = guestPaths32 ++ guestPaths64;
      };

      EGL = {
        name = "libEGL";
        packages = pkgs: [ pkgs.libglvnd ];
        names = enumSuffixes "libEGL.so" [
          ".1"
          ".1.1.0"
        ];
        extraHostPaths = [ "/run/opengl-driver/lib" ];
        extraGuestPaths = guestPaths32 ++ guestPaths64;
      };

      Vulkan = {
        name = "libvulkan";
        packages = pkgs: [ pkgs.vulkan-loader ];
        names = enumSuffixes "libvulkan.so" [
          ".1"
          ".1.3.239"
          ".1.4.313"
          ".1.4.341"
        ];
        hostPackages = with pkgs; [
          libx11
          libxcb
          libxrandr
          libxrender
          xorgproto
        ];
        extraHostPaths = [ "/run/opengl-driver/lib" ];
        extraGuestPaths = guestPaths64;
      };

      drm = {
        name = "libdrm";
        names = enumSuffixes "libdrm.so" [
          ".2"
          ".2.4.0"
          ".2.124.0"
        ];
        extraGuestPaths = guestPaths64;
      };

      asound = {
        # TODO: this breaks steam
        enable = lib.mkDefault false;
        name = "libasound";
        packages = pkgs: [ pkgs.alsa-lib ];
        names = enumSuffixes "libasound.so" [
          ".2"
          ".2.0.0"
        ];
        extraGuestPaths = guestPaths64;
      };

      WaylandClient = {
        name = "libwayland-client";
        packages = pkgs: [ pkgs.wayland ];
        names = enumSuffixes "libwayland-client.so" [
          ".0"
          ".0.3.0"
          ".0.20.0"
          ".0.24.0"
        ];
        extraGuestPaths = guestPaths32 ++ guestPaths64;
      };
    };

    nix.settings = lib.mkIf cfg.addToNixSandbox {
      extra-platforms = [
        "x86_64-linux"
        "i386-linux"
      ];
      extra-sandbox-paths = [
        "/run/binfmt"
        "${cfg.package}"
        "${wrappedHostThunks}"
      ]
      ++ lib.mapAttrsToList (_: library: "${library.wrappedThunk}") cfg.forwardedLibraries;
    };
  };

  meta.maintainers = with lib.maintainers; [ andre4ik3 ];
}
