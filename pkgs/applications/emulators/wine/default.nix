## Configuration:
# Control you default wine config in nixpkgs-config:
# wine = {
#   release = "stable"; # "stable", "unstable", "staging", "wayland"
#   build = "wineWow"; # "wine32", "wine64", "wineWow"
# };
# Make additional configurations on demand:
# wine.override { wineBuild = "wine32"; wineRelease = "staging"; };
{ lib, stdenv, callPackage, darwin,
  wineRelease ? "stable",
  wineBuild ? if stdenv.hostPlatform.system == "x86_64-linux" then "wineWow" else "wine32",
  gettextSupport ? false,
  fontconfigSupport ? false,
  alsaSupport ? false,
  gtkSupport ? false,
  openglSupport ? false,
  tlsSupport ? false,
  gstreamerSupport ? false,
  cupsSupport ? false,
  dbusSupport ? false,
  openalSupport ? false,
  openclSupport ? false,
  cairoSupport ? false,
  odbcSupport ? false,
  netapiSupport ? false,
  cursesSupport ? false,
  vaSupport ? false,
  pcapSupport ? false,
  v4lSupport ? false,
  saneSupport ? false,
  gphoto2Support ? false,
  krb5Support ? false,
  ldapSupport ? false,
  pulseaudioSupport ? false,
  udevSupport ? false,
  xineramaSupport ? false,
  vulkanSupport ? false,
  sdlSupport ? false,
  vkd3dSupport ? false,
  usbSupport ? false,
  mingwSupport ? wineRelease != "stable",
  waylandSupport ? wineRelease == "wayland",
  embedInstallers ? false, # The Mono and Gecko MSI installers
  moltenvk ? darwin.moltenvk # Allow users to override MoltenVK easily
}:

let wine-build = build: release:
      lib.getAttr build (callPackage ./packages.nix {
        wineRelease = release;
        supportFlags = {
          inherit
            cupsSupport gettextSupport dbusSupport openalSupport cairoSupport
            odbcSupport netapiSupport cursesSupport vaSupport pcapSupport
            v4lSupport saneSupport gphoto2Support krb5Support ldapSupport fontconfigSupport
            alsaSupport pulseaudioSupport xineramaSupport gtkSupport openclSupport
            tlsSupport openglSupport gstreamerSupport udevSupport vulkanSupport
            sdlSupport usbSupport vkd3dSupport mingwSupport waylandSupport embedInstallers;
        };
        inherit moltenvk;
      });

in if wineRelease == "staging" then
  callPackage ./staging.nix {
    wineUnstable = wine-build wineBuild "unstable";
  }
else
  wine-build wineBuild wineRelease
