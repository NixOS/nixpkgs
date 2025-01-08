{ config, options, lib, pkgs, utils, modules, baseModules, extraModules, modulesPath, specialArgs, ... }:

let
  cfg = config.documentation;
  allOpts = options;

  canCacheDocs = m:
    let
      f = import m;
      instance = f (lib.mapAttrs (n: _: abort "evaluating ${n} for `meta` failed") (lib.functionArgs f));
    in
      cfg.nixos.options.splitBuild
        && lib.isPath m
        && lib.isFunction f
        && instance ? options
        && instance.meta.buildDocsInSandbox or true;

  docModules =
    let
      p = lib.partition canCacheDocs (baseModules ++ cfg.nixos.extraModules);
    in
      {
        lazy = p.right;
        eager = p.wrong ++ lib.optionals cfg.nixos.includeAllModules (extraModules ++ modules);
      };

  manual = import ../../doc/manual rec {
    inherit pkgs config;
    version = config.system.nixos.release;
    revision = "release-${version}";
    extraSources = cfg.nixos.extraModuleSources;
    options =
      let
        scrubbedEval = lib.evalModules {
          modules = [ {
            _module.check = false;
          } ] ++ docModules.eager;
          class = "nixos";
          specialArgs = specialArgs // {
            pkgs = scrubDerivations "pkgs" pkgs;
            # allow access to arbitrary options for eager modules, eg for getting
            # option types from lazy modules
            options = allOpts;
            inherit modulesPath utils;
          };
        };
        scrubDerivations = namePrefix: pkgSet: lib.mapAttrs
          (name: value:
            let
              wholeName = "${namePrefix}.${name}";
              guard = lib.warn "Attempt to evaluate package ${wholeName} in option documentation; this is not supported and will eventually be an error. Use `mkPackageOption{,MD}` or `literalExpression` instead.";
            in if lib.isAttrs value then
              scrubDerivations wholeName value
              // lib.optionalAttrs (lib.isDerivation value) {
                outPath = guard "\${${wholeName}}";
                drvPath = guard value.drvPath;
              }
            else value
          )
          pkgSet;
      in scrubbedEval.options;

    baseOptionsJSON =
      let
        filter =
          builtins.filterSource
            (n: t:
              lib.cleanSourceFilter n t
              && (t == "directory" -> baseNameOf n != "tests")
              && (t == "file" -> lib.hasSuffix ".nix" n)
            );
      in
        pkgs.runCommand "lazy-options.json" {
          libPath = filter (pkgs.path + "/lib");
          pkgsLibPath = filter (pkgs.path + "/pkgs/pkgs-lib");
          nixosPath = filter (pkgs.path + "/nixos");
          NIX_ABORT_ON_WARN = warningsAreErrors;
          modules =
            "[ "
            + lib.concatMapStringsSep " " (p: ''"${lib.removePrefix "${modulesPath}/" (toString p)}"'') docModules.lazy
            + " ]";
          passAsFile = [ "modules" ];
        } ''
          export NIX_STORE_DIR=$TMPDIR/store
          export NIX_STATE_DIR=$TMPDIR/state
          ${pkgs.buildPackages.nix}/bin/nix-instantiate \
            --show-trace \
            --eval --json --strict \
            --argstr libPath "$libPath" \
            --argstr pkgsLibPath "$pkgsLibPath" \
            --argstr nixosPath "$nixosPath" \
            --arg modules "import $modulesPath" \
            --argstr stateVersion "${options.system.stateVersion.default}" \
            --argstr release "${config.system.nixos.release}" \
            $nixosPath/lib/eval-cacheable-options.nix > $out \
            || {
              echo -en "\e[1;31m"
              echo 'Cacheable portion of option doc build failed.'
              echo 'Usually this means that an option attribute that ends up in documentation (eg' \
                '`default` or `description`) depends on the restricted module arguments' \
                '`config` or `pkgs`.'
              echo
              echo 'Rebuild your configuration with `--show-trace` to find the offending' \
                'location. Remove the references to restricted arguments (eg by escaping' \
                'their antiquotations or adding a `defaultText`) or disable the sandboxed' \
                'build for the failing module by setting `meta.buildDocsInSandbox = false`.'
              echo -en "\e[0m"
              exit 1
            } >&2
        '';

    inherit (cfg.nixos.options) warningsAreErrors;
  };


  nixos-help = let
    helpScript = pkgs.writeShellScriptBin "nixos-help" ''
      # Finds first executable browser in a colon-separated list.
      # (see how xdg-open defines BROWSER)
      browser="$(
        IFS=: ; for b in $BROWSER; do
          [ -n "$(type -P "$b" || true)" ] && echo "$b" && break
        done
      )"
      if [ -z "$browser" ]; then
        browser="$(type -P xdg-open || true)"
        if [ -z "$browser" ]; then
          browser="${pkgs.w3m-nographics}/bin/w3m"
        fi
      fi
      exec "$browser" ${manual.manualHTMLIndex}
    '';

    desktopItem = pkgs.makeDesktopItem {
      name = "nixos-manual";
      desktopName = "NixOS Manual";
      genericName = "System Manual";
      comment = "View NixOS documentation in a web browser";
      icon = "nix-snowflake";
      exec = "nixos-help";
      categories = ["System"];
    };

    in pkgs.symlinkJoin {
      name = "nixos-help";
      paths = [
        helpScript
        desktopItem
      ];
    };

in

{
  imports = [
    ./man-db.nix
    ./mandoc.nix
    ./assertions.nix
    ./meta.nix
    ../config/system-path.nix
    ../system/etc/etc.nix
    (lib.mkRenamedOptionModule [ "programs" "info" "enable" ] [ "documentation" "info" "enable" ])
    (lib.mkRenamedOptionModule [ "programs" "man"  "enable" ] [ "documentation" "man"  "enable" ])
    (lib.mkRenamedOptionModule [ "services" "nixosManual" "enable" ] [ "documentation" "nixos" "enable" ])
    (lib.mkRemovedOptionModule
      [ "documentation" "nixos" "options" "allowDocBook" ]
      "DocBook option documentation is no longer supported")
  ];

  options = {

    documentation = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install documentation of packages from
          {option}`environment.systemPackages` into the generated system path.

          See "Multiple-output packages" chapter in the nixpkgs manual for more info.
        '';
        # which is at ../../../doc/multiple-output.chapter.md
      };

      man.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install manual pages.
          This also includes `man` outputs.
        '';
      };

      man.generateCaches = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to generate the manual page index caches.
          This allows searching for a page or
          keyword using utilities like {manpage}`apropos(1)`
          and the `-k` option of
          {manpage}`man(1)`.
        '';
      };

      info.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install info pages and the {command}`info` command.
          This also includes "info" outputs.
        '';
      };

      doc.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install documentation distributed in packages' `/share/doc`.
          Usually plain text and/or HTML.
          This also includes "doc" outputs.
        '';
      };

      dev.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to install documentation targeted at developers.
          * This includes man pages targeted at developers if {option}`documentation.man.enable` is
            set (this also includes "devman" outputs).
          * This includes info pages targeted at developers if {option}`documentation.info.enable`
            is set (this also includes "devinfo" outputs).
          * This includes other pages targeted at developers if {option}`documentation.doc.enable`
            is set (this also includes "devdoc" outputs).
        '';
      };

      nixos.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install NixOS's own documentation.

          - This includes man pages like
            {manpage}`configuration.nix(5)` if {option}`documentation.man.enable` is
            set.
          - This includes the HTML manual and the {command}`nixos-help` command if
            {option}`documentation.doc.enable` is set.
        '';
      };

      nixos.extraModules = lib.mkOption {
        type = lib.types.listOf lib.types.raw;
        default = [];
        description = ''
          Modules for which to show options even when not imported.
        '';
      };

      nixos.options.splitBuild = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to split the option docs build into a cacheable and an uncacheable part.
          Splitting the build can substantially decrease the amount of time needed to build
          the manual, but some user modules may be incompatible with this splitting.
        '';
      };

      nixos.options.warningsAreErrors = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Treat warning emitted during the option documentation build (eg for missing option
          descriptions) as errors.
        '';
      };

      nixos.includeAllModules = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether the generated NixOS's documentation should include documentation for all
          the options from all the NixOS modules included in the current
          `configuration.nix`. Disabling this will make the manual
          generator to ignore options defined outside of `baseModules`.
        '';
      };

      nixos.extraModuleSources = lib.mkOption {
        type = lib.types.listOf (lib.types.either lib.types.path lib.types.str);
        default = [ ];
        description = ''
          Which extra NixOS module paths the generated NixOS's documentation should strip
          from options.
        '';
        example = lib.literalExpression ''
          # e.g. with options from modules in ''${pkgs.customModules}/nix:
          [ pkgs.customModules ]
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.man.man-db.enable && cfg.man.mandoc.enable);
          message = ''
            man-db and mandoc can't be used as the default man page viewer at the same time!
          '';
        }
      ];
    }

    # The actual implementation for this lives in man-db.nix or mandoc.nix,
    # depending on which backend is active.
    (lib.mkIf cfg.man.enable {
      environment.pathsToLink = [ "/share/man" ];
      environment.extraOutputsToInstall = [ "man" ] ++ lib.optional cfg.dev.enable "devman";
    })

    (lib.mkIf cfg.info.enable {
      environment.systemPackages = [ pkgs.texinfoInteractive ];
      environment.pathsToLink = [ "/share/info" ];
      environment.extraOutputsToInstall = [ "info" ] ++ lib.optional cfg.dev.enable "devinfo";
      environment.extraSetup = ''
        if [ -w $out/share/info ]; then
          shopt -s nullglob
          for i in $out/share/info/*.info $out/share/info/*.info.gz; do
              ${pkgs.buildPackages.texinfo}/bin/install-info $i $out/share/info/dir
          done
        fi
      '';
    })

    (lib.mkIf cfg.doc.enable {
      environment.pathsToLink = [
        "/share/doc"

        # Legacy paths used by gtk-doc & adjacent tools.
        "/share/gtk-doc"
        "/share/devhelp"
      ];
      environment.extraOutputsToInstall = [ "doc" ] ++ lib.optional cfg.dev.enable "devdoc";
    })

    (lib.mkIf cfg.nixos.enable {
      system.build.manual = manual;

      environment.systemPackages = []
        ++ lib.optional cfg.man.enable manual.nixos-configuration-reference-manpage
        ++ lib.optionals cfg.doc.enable [ manual.manualHTML nixos-help ];
    })

  ]);

}
