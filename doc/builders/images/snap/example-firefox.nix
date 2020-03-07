let
  inherit (import <nixpkgs> { }) snapTools firefox;
in snapTools.makeSnap {
  meta = {
    name = "nix-example-firefox";
    summary = firefox.meta.description;
    architectures = [ "amd64" ];
    apps.nix-example-firefox = {
      command = "${firefox}/bin/firefox";
      plugs = [
        "pulseaudio"
        "camera"
        "browser-support"
        "avahi-observe"
        "cups-control"
        "desktop"
        "desktop-legacy"
        "gsettings"
        "home"
        "network"
        "mount-observe"
        "removable-media"
        "x11"
      ];
    };
    confinement = "strict";
  };
}
