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

  options.system.switch.enable = lib.mkOption {
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

  config = lib.mkIf config.system.switch.enable {
    # Use a subshell so we can source makeWrapper's setup hook without
    # affecting the rest of activatableSystemBuilderCommands.
    system.activatableSystemBuilderCommands = ''
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
  };
}
