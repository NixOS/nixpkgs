{ config, pkgs, lib, utils, ... }:

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

  wrapThunk = {
    name,
    hostRpath,
    guestRpath,
    guestNeeds ? [ ],
  }: pkgs.runCommandLocal "fex-thunk-${name}" {
    buildInputs = [ pkgs.patchelf ];

    hostName = "${name}-host.so";
    hostPath = "lib/fex-emu/HostThunks";
    hostArgs = "--set-rpath ${hostRpath}";

    guestName = "${name}-guest.so";
    guestPath = "share/fex-emu/GuestThunks";
    guestArgs = lib.concatStringsSep " " ([
      "--add-rpath" guestRpath
    ] ++ lib.map (x: "--add-needed ${x}") guestNeeds);

  } ''
    doPatch() {
      mkdir -p "$(dirname "$out/$1")"
      patchelf "$1" --output "$out/$1" $2
    }

    echo "wrapping thunk '${name}'..."
    pushd "${cfg.package}"

    doPatch "$hostPath/$hostName" "$hostArgs"
    if [ -f "$hostPath_32/$hostName" ]; then
      doPatch "$hostPath_32/$hostName" "$hostArgs"
    fi

    doPatch "$guestPath/$guestName" "$guestArgs"
    if [ -f "$guestPath_32/$guestName" ]; then
      doPatch "$guestPath_32/$guestName" "$guestArgs"
    fi
  '';

  forwardedLibrarySubmodule = lib.types.submodule ({ name, config, ... }: {
    options = {
      enable = lib.mkEnableOption "forwarding this library" // { default = true; };

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
        default = pkgs: [ pkgs.${name} ];
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
          The wrapped host and guest thunks for this library.
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

    config = {
      wrappedThunk = wrapThunk {
        inherit (config) name;

        hostRpath = let
          packagePaths = lib.map mkLibPath (config.packages pkgs ++ config.hostPackages);
        in lib.concatStringsSep ":" (packagePaths ++ config.extraHostPaths);

        # TODO make this configurable and not a hack
        guestRpath = lib.makeLibraryPath (lib.concatMap cfg.extraPackages cfg.guestPackageSets);
        guestNeeds = [ "libstdc++.so.6" ];
      };

      overlayPaths = lib.map (x: "${x.path}/${x.name}") (lib.cartesianProduct {
        name = config.names;
        path = lib.map mkLibPath' (
          (lib.concatMap (
            set: config.packages set ++ config.guestPackages set
          ) cfg.guestPackageSets) ++ config.extraGuestPaths);
      });
    };
  });

  thunks = pkgs.symlinkJoin {
    name = "fex-thunks";
    paths = lib.mapAttrsToList (_: library: library.wrappedThunk) cfg.forwardedLibraries;
  };

  enumSuffixes = base: suffixes: lib.map (x: x.base + x.suffix) (lib.cartesianProduct {
    base = [ base ];
    suffix = suffixes ++ [ "" ];
  });

  convertConfig = lib.mapAttrs (_: value:
    if builtins.isBool value
      then (if value then "1" else "0")
    else if builtins.isList value
      then builtins.map convertConfig value
    else if builtins.isAttrs value
      then builtins.mapAttrs (_: convertConfig) value
    else toString value
  );
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

    extraPackages = lib.mkOption {
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
      default = pkgs: [ ];
      defaultText = lib.literalExpression "pkgs: [ ]";
      description = ''
        Additional packages to add to the guest dynamic library path.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf (lib.types.oneOf [
        lib.types.bool
        lib.types.str
        (lib.types.listOf lib.types.str)
        lib.types.int
      ]);
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
      assertion = pkgs.hostPlatform.isAarch64;
      message = "FEX emulation is only supported on aarch64.";
    };

    # TODO split lib paths in FEX package so wrong thunks don't get put in path
    environment.systemPackages = [ cfg.package ];
    boot.binfmt.registrations = {
      "FEX-x86" = common // utils.binfmtMagics.i386-linux;
      "FEX-x86_64" = common // utils.binfmtMagics.x86_64-linux;
    };

    environment.etc = {
      "fex-emu/ThunksDB.json".text = builtins.toJSON {
        DB = lib.mapAttrs (_: library: {
          Library = "${library.name}-guest.so";
          Overlay = library.overlayPaths;
        }) cfg.forwardedLibraries;
      };
      "fex-emu/Config.json".text = builtins.toJSON {
        Config = {
          ThunkGuestLibs = "${thunks}/share/fex-emu/GuestThunks";
          ThunkHostLibs = "${thunks}/lib/fex-emu/HostThunks";
        } // convertConfig cfg.settings;
        ThunksDB = lib.mapAttrs (name: library: if library.enable then 1 else 0) cfg.forwardedLibraries;
      };
    };

    # Libraries that are forwarded by default. NOTE: added libraries must have
    # a corresponding `{name}-{host,guest}.so` shared object built by FEX. The
    # below configuration encompasses all such libraries currently in FEX.
    virtualisation.fex.forwardedLibraries = {
      libGL.names = enumSuffixes "libGL.so" [ ".1" ".1.2.0" ".1.7.0" ];

      libvulkan = {
        packages = pkgs: [ pkgs.vulkan-loader ];
        names = enumSuffixes "libvulkan.so" [ ".1" ".1.4.313" ];
      };

      libdrm.names = enumSuffixes "libdrm.so" [ ".2" ".2.4.0" ".2.124.0" ];

      libasound = {
        packages = pkgs: [ pkgs.alsa-lib ];
        names = enumSuffixes "libasound.so" [ ".2" ".2.0.0" ];
      };

      libwayland-client = {
        packages = pkgs: [ pkgs.wayland ];
        names = enumSuffixes "libwayland-client.so" [ ".0" ".0.20.0" ".0.24.0" ];
      };
    };

    nix.settings = lib.mkIf cfg.addToNixSandbox {
      extra-platforms = [ "x86_64-linux" "i386-linux" ];
      extra-sandbox-paths = [ "/run/binfmt" "${cfg.package}" ];
    };
  };

  meta.maintainers = with lib.maintainers; [ andre4ik3 ];
}
