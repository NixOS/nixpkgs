{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    (lib.mkRemovedOptionModule [ "system" "switch" "enableNg" ] ''
      This option controlled the usage of the new switch-to-configuration-ng,
      which is now the only switch-to-configuration implementation. This option
      can be removed from configuration. If there are outstanding issues
      preventing you from using the new implementation, please open an issue on
      GitHub.
    '')
  ];

  options.system.switch = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to include the capability to switch configurations.

        Disabling this makes the system unable to be reconfigured via `nixos-rebuild`.

        This is good for image based appliances where updates are handled
        outside the image. Reducing features makes the image lighter and
        slightly more secure.
      '';
    };

    inhibitors = lib.mkOption {
      type = lib.types.listOf lib.types.pathInStore;
      default = [ ];
      description = ''
        List of derivations that will prevent switching into a configuration when
        they change.
        This can be manually overridden on the command line if required.
      '';
    };
  };

  config = lib.mkIf config.system.switch.enable {
    # Use a subshell so we can source makeWrapper's setup hook without
    # affecting the rest of activatableSystemBuilderCommands.
    system = {
      activatableSystemBuilderCommands = ''
        (
          source ${pkgs.buildPackages.makeWrapper}/nix-support/setup-hook

          mkdir $out/bin
          ln -sf ${lib.getExe pkgs.switch-to-configuration-ng} $out/bin/switch-to-configuration
          wrapProgram $out/bin/switch-to-configuration \
            --set OUT $out \
            --set TOPLEVEL ''${!toplevelVar} \
            --set DISTRO_ID ${lib.escapeShellArg config.system.nixos.distroId} \
            --set INSTALL_BOOTLOADER ${lib.escapeShellArg config.system.build.installBootLoader} \
            --set PRE_SWITCH_CHECK ${lib.escapeShellArg config.system.preSwitchChecksScript} \
            --set LOCALE_ARCHIVE ${config.i18n.glibcLocales}/lib/locale/locale-archive \
            --set SYSTEMD ${config.systemd.package}
        )
      '';

      systemBuilderCommands = ''
        ln -s ${config.system.build.inhibitSwitch} $out/switch-inhibitors
      '';

      build.inhibitSwitch = pkgs.writeTextFile {
        name = "switch-inhibitors";
        text = lib.concatMapStringsSep "\n" (drv: drv.outPath) config.system.switch.inhibitors;
      };

      preSwitchChecks.switchInhibitors =
        let
          realpath = lib.getExe' pkgs.coreutils "realpath";
          sha256sum = lib.getExe' pkgs.coreutils "sha256sum";
          diff = lib.getExe' pkgs.diffutils "diff";
        in
        # bash
        ''
          incoming="''${1-}"
          action="''${2-}"

          if [ "$action" == "boot" ]; then
            echo "Not checking switch inhibitors (action = $action)"
            exit
          fi

          echo -n "Checking switch inhibitors..."

          booted_inhibitors="$(${realpath} /run/booted-system)/switch-inhibitors"
          booted_inhibitors_sha="$(
            if [ -f "$booted_inhibitors" ]; then
              ${sha256sum} - < "$booted_inhibitors"
            else
              echo 'none'
            fi
          )"

          if [ "$booted_inhibitors_sha" == "none" ]; then
            echo
            echo "The previous configuration did not specify switch inhibitors, nothing to check."
            exit
          fi

          new_inhibitors="$(${realpath} "$incoming")/switch-inhibitors"
          new_inhibitors_sha="$(
            if [ -f "$new_inhibitors" ]; then
              ${sha256sum} - < "$new_inhibitors"
            else
              echo 'none'
            fi
          )"

          if [ "$new_inhibitors_sha" == "none" ]; then
            echo
            echo "The new configuration does not specify switch inhibitors, nothing to check."
            exit
          fi

          if [ "$new_inhibitors_sha" != "$booted_inhibitors_sha" ]; then
            echo
            echo "Found diff in switch inhibitors:"
            echo
            ${diff} --color "$booted_inhibitors" "$new_inhibitors"
            echo
            echo "The new configuration contains changes to packages that were"
            echo "listed as switch inhibitors."
            echo
            echo "If you really want to switch into this configuration directly, then"
            echo "you can set NIXOS_NO_CHECK=1 to ignore these pre-switch checks."
            echo
            echo "WARNING: doing so might cause the switch to fail or your system to become unstable."
            echo
            exit 1
          else
            echo " done"
          fi
        '';
    };
  };
}
