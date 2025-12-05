{
  lib,
  pkgs,
  ...
}:
let
  firefoxLib = import ./lib.nix;
in
{
  imports = [
    (firefoxLib.mkFirefoxBaseModule {
      variant = "firefox";
      prettyName = "Firefox";
      defaultPackage = pkgs.firefox;
      relatedPackages = [
        "firefox"
        "firefox-bin"
        "firefox-esr"
      ];
    })
  ]
  ++ (lib.mapAttrsToList
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
    }
  );

  meta.maintainers = with lib.maintainers; [
    danth
    linsui
  ];
}
