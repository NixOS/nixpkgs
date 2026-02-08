## Configuration:
# Control you default wine config in nixpkgs-config:
# wine = {
#   release = "stable"; # "stable", "unstable", "staging", "wayland"
#   build = "wineWow"; # "wine32", "wine64", "wineWow"
# };
# Make additional configurations on demand:
# wine.override { wineBuild = "wine32"; wineRelease = "staging"; };
{
  lib,
  stdenv,
  callPackage,
  darwin,
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
  pulseaudioSupport ? false,
  udevSupport ? false,
  xineramaSupport ? false,
  vulkanSupport ? false,
  sdlSupport ? false,
  usbSupport ? false,
  mingwSupport ? stdenv.hostPlatform.isDarwin,
  waylandSupport ? false,
  x11Support ? false,
  ffmpegSupport ? false,
  embedInstallers ? false, # The Mono and Gecko MSI installers
  moltenvk, # Allow users to override MoltenVK easily
}:

let
  sources = callPackage ./sources.nix { };

  # Map user-facing release names to sources, pname suffix, and staging flag
  releaseInfo = {
    stable = {
      src = sources.stable;
      useStaging = false;
    };
    unstable = {
      src = sources.unstable;
      useStaging = false;
    };
    # Many versions have a "staging" variant, but when we say "staging",
    # the version we want to use is "unstable".
    staging = {
      src = sources.unstable;
      pnameSuffix = "-staging";
      useStaging = true;
    };
    # "yabridge" enables staging too --- we are not interested in
    # yabridge without the staging patches applied.
    yabridge = {
      src = sources.yabridge;
      pnameSuffix = "-yabridge";
      useStaging = true;
    };
  };

  baseWine = lib.getAttr wineBuild (
    callPackage ./packages.nix (
      releaseInfo.${wineRelease}
      // {
        supportFlags = {
          inherit
            alsaSupport
            cairoSupport
            cupsSupport
            cursesSupport
            dbusSupport
            embedInstallers
            fontconfigSupport
            gettextSupport
            gphoto2Support
            gstreamerSupport
            gtkSupport
            krb5Support
            mingwSupport
            netapiSupport
            odbcSupport
            openclSupport
            openglSupport
            pcapSupport
            pulseaudioSupport
            saneSupport
            sdlSupport
            tlsSupport
            udevSupport
            usbSupport
            v4lSupport
            vaSupport
            vulkanSupport
            waylandSupport
            x11Support
            ffmpegSupport
            xineramaSupport
            ;
        };
        inherit moltenvk;
      }
    )
  );
in
if wineRelease == "yabridge" then
  baseWine.overrideAttrs (old: {
    env = old.env // {
      NIX_CFLAGS_COMPILE = "-std=gnu17";
    };
  })
else
  baseWine
