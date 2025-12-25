mkFirefoxBaseModule:
{
  lib,
  pkgs,
  ...
}:
let
  baseModule = mkFirefoxBaseModule {
    variant = "firefox";
    prettyName = "Firefox";
    defaultPackage = pkgs.firefox;
    relatedPackages = [
      "firefox"
      "firefox-bin"
      "firefox-esr"
    ];
  };
in
{
  imports =
    lib.mapAttrsToList
      (
        name: pkg:
        lib.mkRemovedOptionModule [
          "programs"
          "firefox"
          "nativeMessagingHosts"
          name
        ] "Use `programs.firefox.nativeMessagingHosts.packages = [ pkgs.${pkg} ]` instead"
      )
      {
        browserpass = "browserpass";
        bukubrow = "bukubrow";
        euwebid = "web-eid-app";
        ff2mpv = "ff2mpv";
        fxCast = "fx-cast-bridge";
        gsconnect = "gnomeExtensions.gsconnect";
        jabref = "jabref";
        passff = "passff-host";
        tridactyl = "tridactyl-native";
        ugetIntegrator = "uget-integrator";
      };

  inherit (baseModule) config options;

  meta.maintainers = with lib.maintainers; [
    danth
    linsui
  ];
}
