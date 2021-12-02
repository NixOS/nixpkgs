{ config, lib, pkgs, extendModules, noUserModules, ... }:

with lib;

let

  cfg = config.documentation;

  /* Modules for which to show options even when not imported. */
  extraDocModules = [ ../virtualisation/qemu-vm.nix ];

  /* For the purpose of generating docs, evaluate options with each derivation
    in `pkgs` (recursively) replaced by a fake with path "\${pkgs.attribute.path}".
    It isn't perfect, but it seems to cover a vast majority of use cases.
    Caveat: even if the package is reached by a different means,
    the path above will be shown and not e.g. `${config.services.foo.package}`. */
  manual = import ../../doc/manual rec {
    inherit pkgs config;
    version = config.system.nixos.release;
    revision = "release-${version}";
    extraSources = cfg.nixos.extraModuleSources;
    options =
      let
        extendNixOS = if cfg.nixos.includeAllModules then extendModules else noUserModules.extendModules;
        scrubbedEval = extendNixOS {
          modules = extraDocModules;
          specialArgs.pkgs = scrubDerivations "pkgs" pkgs;
        };
        scrubDerivations = namePrefix: pkgSet: mapAttrs
          (name: value:
            let wholeName = "${namePrefix}.${name}"; in
            if isAttrs value then
              scrubDerivations wholeName value
              // (optionalAttrs (isDerivation value) { outPath = "\${${wholeName}}"; })
            else value
          )
          pkgSet;
      in scrubbedEval.options;
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
      genericName = "View NixOS documentation in a web browser";
      icon = "nix-snowflake";
      exec = "nixos-help";
      categories = "System";
    };

    in pkgs.symlinkJoin {
      name = "nixos-help";
      paths = [
        helpScript
        desktopItem
      ];
    };

  # list of man outputs currently active intended for use as default values
  # for man-related options, thus "man" is included unconditionally.
  activeManOutputs = [ "man" ] ++ lib.optionals cfg.dev.enable [ "devman" ];

in

{
  imports = [
    (mkRenamedOptionModule [ "programs" "info" "enable" ] [ "documentation" "info" "enable" ])
    (mkRenamedOptionModule [ "programs" "man"  "enable" ] [ "documentation" "man"  "enable" ])
    (mkRenamedOptionModule [ "services" "nixosManual" "enable" ] [ "documentation" "nixos" "enable" ])
  ];

  options = {

    documentation = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install documentation of packages from
          <option>environment.systemPackages</option> into the generated system path.

          See "Multiple-output packages" chapter in the nixpkgs manual for more info.
        '';
        # which is at ../../../doc/multiple-output.chapter.md
      };

      man.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install manual pages and the <command>man</command> command.
          This also includes "man" outputs.
        '';
      };

      man.generateCaches = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to generate the manual page index caches using
          <literal>mandb(8)</literal>. This allows searching for a page or
          keyword using utilities like <literal>apropos(1)</literal>.
        '';
      };

      man.manualPages = mkOption {
        type = types.path;
        default = pkgs.buildEnv {
          name = "man-paths";
          paths = config.environment.systemPackages;
          pathsToLink = [ "/share/man" ];
          extraOutputsToInstall = activeManOutputs;
          ignoreCollisions = true;
        };
        defaultText = literalDocBook "all man pages in <option>config.environment.systemPackages</option>";
        description = ''
          The manual pages to generate caches for if <option>generateCaches</option>
          is enabled. Must be a path to a directory with man pages under
          <literal>/share/man</literal>; see the source for an example.
          Advanced users can make this a content-addressed derivation to save a few rebuilds.
        '';
      };

      info.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install info pages and the <command>info</command> command.
          This also includes "info" outputs.
        '';
      };

      doc.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install documentation distributed in packages' <literal>/share/doc</literal>.
          Usually plain text and/or HTML.
          This also includes "doc" outputs.
        '';
      };

      dev.enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to install documentation targeted at developers.
          <itemizedlist>
          <listitem><para>This includes man pages targeted at developers if <option>documentation.man.enable</option> is
                    set (this also includes "devman" outputs).</para></listitem>
          <listitem><para>This includes info pages targeted at developers if <option>documentation.info.enable</option>
                    is set (this also includes "devinfo" outputs).</para></listitem>
          <listitem><para>This includes other pages targeted at developers if <option>documentation.doc.enable</option>
                    is set (this also includes "devdoc" outputs).</para></listitem>
          </itemizedlist>
        '';
      };

      nixos.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install NixOS's own documentation.
          <itemizedlist>
          <listitem><para>This includes man pages like
                    <citerefentry><refentrytitle>configuration.nix</refentrytitle>
                    <manvolnum>5</manvolnum></citerefentry> if <option>documentation.man.enable</option> is
                    set.</para></listitem>
          <listitem><para>This includes the HTML manual and the <command>nixos-help</command> command if
                    <option>documentation.doc.enable</option> is set.</para></listitem>
          </itemizedlist>
        '';
      };

      nixos.includeAllModules = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether the generated NixOS's documentation should include documentation for all
          the options from all the NixOS modules included in the current
          <literal>configuration.nix</literal>. Disabling this will make the manual
          generator to ignore options defined outside of <literal>baseModules</literal>.
        '';
      };

      nixos.extraModuleSources = mkOption {
        type = types.listOf (types.either types.path types.str);
        default = [ ];
        description = ''
          Which extra NixOS module paths the generated NixOS's documentation should strip
          from options.
        '';
        example = literalExpression ''
          # e.g. with options from modules in ''${pkgs.customModules}/nix:
          [ pkgs.customModules ]
        '';
      };

    };

  };

  config = mkIf cfg.enable (mkMerge [

    (mkIf cfg.man.enable {
      environment.systemPackages = [ pkgs.man-db ];
      environment.pathsToLink = [ "/share/man" ];
      environment.extraOutputsToInstall = activeManOutputs;
      environment.etc."man_db.conf".text =
        let
          manualCache = pkgs.runCommandLocal "man-cache" { } ''
            echo "MANDB_MAP ${cfg.man.manualPages}/share/man $out" > man.conf
            ${pkgs.man-db}/bin/mandb -C man.conf -psc >/dev/null 2>&1
          '';
        in
        ''
          # Manual pages paths for NixOS
          MANPATH_MAP /run/current-system/sw/bin /run/current-system/sw/share/man
          MANPATH_MAP /run/wrappers/bin          /run/current-system/sw/share/man

          ${optionalString cfg.man.generateCaches ''
          # Generated manual pages cache for NixOS (immutable)
          MANDB_MAP /run/current-system/sw/share/man ${manualCache}
          ''}
          # Manual pages caches for NixOS
          MANDB_MAP /run/current-system/sw/share/man /var/cache/man/nixos
        '';
    })

    (mkIf cfg.info.enable {
      environment.systemPackages = [ pkgs.texinfoInteractive ];
      environment.pathsToLink = [ "/share/info" ];
      environment.extraOutputsToInstall = [ "info" ] ++ optional cfg.dev.enable "devinfo";
      environment.extraSetup = ''
        if [ -w $out/share/info ]; then
          shopt -s nullglob
          for i in $out/share/info/*.info $out/share/info/*.info.gz; do
              ${pkgs.buildPackages.texinfo}/bin/install-info $i $out/share/info/dir
          done
        fi
      '';
    })

    (mkIf cfg.doc.enable {
      environment.pathsToLink = [ "/share/doc" ];
      environment.extraOutputsToInstall = [ "doc" ] ++ optional cfg.dev.enable "devdoc";
    })

    (mkIf cfg.nixos.enable {
      system.build.manual = manual;

      environment.systemPackages = []
        ++ optional cfg.man.enable manual.manpages
        ++ optionals cfg.doc.enable [ manual.manualHTML nixos-help ];

      services.getty.helpLine = mkIf cfg.doc.enable (
          "\nRun 'nixos-help' for the NixOS manual."
      );
    })

  ]);

}
