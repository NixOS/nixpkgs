{ config, lib, pkgs, baseModules, extraModules, modules, modulesPath, ... }:

with lib;

let

  cfg = config.documentation;

  manualModules = baseModules ++ optionals cfg.nixos.includeAllModules (extraModules ++ modules);

  /* For the purpose of generating docs, evaluate options with each derivation
    in `pkgs` (recursively) replaced by a fake with path "\${pkgs.attribute.path}".
    It isn't perfect, but it seems to cover a vast majority of use cases.
    Caveat: even if the package is reached by a different means,
    the path above will be shown and not e.g. `${config.services.foo.package}`. */
  manual = import ../../doc/manual rec {
    inherit pkgs config;
    version = config.system.nixos.release;
    revision = "release-${version}";
    options =
      let
        scrubbedEval = evalModules {
          modules = [ { nixpkgs.localSystem = config.nixpkgs.localSystem; } ] ++ manualModules;
          args = (config._module.args) // { modules = [ ]; };
          specialArgs = {
            pkgs = scrubDerivations "pkgs" pkgs;
            inherit modulesPath;
          };
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

  helpScript = pkgs.writeScriptBin "nixos-help"
    ''
      #! ${pkgs.runtimeShell} -e
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
    exec = "${helpScript}/bin/nixos-help";
    categories = "System";
  };

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
        # which is at ../../../doc/multiple-output.xml
      };

      man.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install manual pages and the <command>man</command> command.
          This also includes "man" outputs.
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
          <listitem><para>This includes man pages targeted at developers if <option>man.enable</option> is
                    set (this also includes "devman" outputs).</para></listitem>
          <listitem><para>This includes info pages targeted at developers if <option>info.enable</option>
                    is set (this also includes "devinfo" outputs).</para></listitem>
          <listitem><para>This includes other pages targeted at developers if <option>doc.enable</option>
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
                    <manvolnum>5</manvolnum></citerefentry> if <option>man.enable</option> is
                    set.</para></listitem>
          <listitem><para>This includes the HTML manual and the <command>nixos-help</command> command if
                    <option>doc.enable</option> is set.</para></listitem>
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

    };

  };

  config = mkIf cfg.enable (mkMerge [

    (mkIf cfg.man.enable {
      environment.systemPackages = [ pkgs.man-db ];
      environment.pathsToLink = [ "/share/man" ];
      environment.extraOutputsToInstall = [ "man" ] ++ optional cfg.dev.enable "devman";
      environment.etc."man.conf".source = "${pkgs.man-db}/etc/man_db.conf";
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
        ++ optionals cfg.doc.enable ([ manual.manualHTML helpScript ]
           ++ optionals config.services.xserver.enable [ desktopItem pkgs.nixos-icons ]);

      services.mingetty.helpLine = mkIf cfg.doc.enable (
          "\nRun `nixos-help` "
        + optionalString config.services.nixosManual.showManual "or press <Alt-F${toString config.services.nixosManual.ttyNumber}> "
        + "for the NixOS manual."
      );
    })

  ]);

}
