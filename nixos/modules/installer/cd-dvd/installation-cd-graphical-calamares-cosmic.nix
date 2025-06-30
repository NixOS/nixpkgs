{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./installation-cd-graphical-calamares.nix ];

  isoImage.edition = lib.mkDefault "cosmic";
  isoImage.configurationName = "COSMIC (Linux LTS)";

  environment.pathsToLink = [ "/share/calamares" ];

  services = {
    desktopManager.cosmic.enable = true;
    displayManager = {
      # Greeter needs to be enabled to handle an idle logout and login
      cosmic-greeter.enable = true;

      # No need to have a lockscreen on an installer ISO, enable autologin
      autoLogin = {
        enable = true;
        user = "nixos";
      };
    };
  };

  systemd.tmpfiles.rules =
    let
      desktopDir = "/home/nixos/Desktop";
      filesInHomePerms = "0644 nixos users -";
      dirsInHomePerms = "0755 nixos users - -";
      CosmicAppList_favorites = "${pkgs.writeText "favorites" ''
        [
            "io.calamares.calamares",
            "firefox",
            "com.system76.CosmicFiles",
            "com.system76.CosmicEdit",
            "com.system76.CosmicTerm",
            "com.system76.CosmicSettings",
        ]''}";
    in
    [
      # Need to create ${desktopDir} first or we get an ownership issue because
      # otherwise ${desktopDir} gets the ownership of `root:root`.
      "d ${desktopDir} ${dirsInHomePerms}"
      "L+ ${desktopDir}/io.calamares.calamares.desktop ${filesInHomePerms} ${pkgs.calamares-nixos}/share/applications/io.calamares.calamares.desktop"
      "L+ ${desktopDir}/firefox.desktop ${filesInHomePerms} ${pkgs.firefox}/share/applications/firefox.desktop"
      "L+ ${desktopDir}/gparted.desktop ${filesInHomePerms} ${pkgs.gparted}/share/applications/gparted.desktop"
      "L+ ${desktopDir}/nixos-manual.desktop ${filesInHomePerms} /run/current-system/sw/share/applications/nixos-manual.desktop"

      # Same as ${desktopDir}, need to create all directories in the hierarchy
      "d /home/nixos/.config ${dirsInHomePerms}"
      "d /home/nixos/.config/cosmic ${dirsInHomePerms}"
      "d /home/nixos/.config/cosmic/com.system76.CosmicAppList ${dirsInHomePerms}"
      "d /home/nixos/.config/cosmic/com.system76.CosmicAppList/v1 ${dirsInHomePerms}"
      "L+ /home/nixos/.config/cosmic/com.system76.CosmicAppList/v1/favorites ${filesInHomePerms} ${CosmicAppList_favorites}"
    ];

  specialisation = {
    cosmic_latest_kernel.configuration =
      { config, ... }:
      {
        imports = [ ./latest-kernel.nix ];
        isoImage.configurationName = lib.mkForce "COSMIC (Linux ${config.boot.kernelPackages.kernel.version})";
      };
  };
}
