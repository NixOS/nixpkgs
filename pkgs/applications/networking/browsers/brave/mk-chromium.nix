# Returns mkChromiumDerivation from the vendored chromium/ tree, with
# Linux-only inputs forced to null on Darwin so callPackage does not
# trip pkgs.meta.platforms checks (e.g. libcap).
{
  lib,
  pkgs,
  stdenv,
  callPackage,
  upstream-info,
  proprietaryCodecs ? true,
  cupsSupport ? stdenv.hostPlatform.isLinux,
  ungoogled ? false,
}:
let
  inherit (stdenv) hostPlatform;
  # Important: do not touch pkgs.<linux-only> on Darwin (eager arg eval).
  linux = name: pkg: if hostPlatform.isDarwin then null else pkg;

  chromiumVersionAtLeast = min-version: lib.versionAtLeast upstream-info.version min-version;
  versionRange =
    min-version: upto-version:
    lib.versionAtLeast upstream-info.version min-version
    && lib.versionOlder upstream-info.version upto-version;

  linuxOnly =
    if hostPlatform.isDarwin then
      {
        libcap = null;
        util-linux = null;
        alsa-lib = null;
        gtk3 = null;
        dbus-glib = null;
        libxscrnsaver = null;
        libxcursor = null;
        libxtst = null;
        libxshmfence = null;
        libGLU = null;
        libGL = null;
        dri-pkgconfig-stub = null;
        libgbm = null;
        pciutils = null;
        speechd-minimal = null;
        libxdamage = null;
        at-spi2-core = null;
        pipewire = null;
        libva = null;
        libdrm = null;
        wayland = null;
        libxkbcommon = null;
        libepoxy = null;
        libevdev = null;
        glibc = null;
        vulkan-loader = null;
        systemdLibs = null;
        libpulseaudio = null;
      }
    else
      {
        libcap = pkgs.libcap;
        util-linux = pkgs.util-linux;
        alsa-lib = pkgs.alsa-lib;
        gtk3 = pkgs.gtk3;
        dbus-glib = pkgs.dbus-glib;
        libxscrnsaver = pkgs.libxscrnsaver;
        libxcursor = pkgs.libxcursor or pkgs.xorg.libXcursor;
        libxtst = pkgs.libxtst or pkgs.xorg.libXtst;
        libxshmfence = pkgs.libxshmfence or pkgs.xorg.libxshmfence;
        libGLU = pkgs.libGLU;
        libGL = pkgs.libGL;
        dri-pkgconfig-stub = pkgs.dri-pkgconfig-stub;
        libgbm = pkgs.libgbm;
        pciutils = pkgs.pciutils;
        speechd-minimal = pkgs.speechd-minimal;
        libxdamage = pkgs.libxdamage or pkgs.xorg.libXdamage;
        at-spi2-core = pkgs.at-spi2-core;
        pipewire = pkgs.pipewire;
        libva = pkgs.libva;
        libdrm = pkgs.libdrm;
        wayland = pkgs.wayland;
        libxkbcommon = pkgs.libxkbcommon;
        libepoxy = pkgs.libepoxy;
        libevdev = pkgs.libevdev;
        glibc = pkgs.glibc;
        vulkan-loader = pkgs.vulkan-loader;
        systemdLibs = pkgs.systemdLibs or pkgs.systemd;
        libpulseaudio = pkgs.libpulseaudio;
      };
in
callPackage ../chromium/common.nix (
  {
    inherit stdenv;
    inherit
      upstream-info
      chromiumVersionAtLeast
      versionRange
      proprietaryCodecs
      cupsSupport
      ungoogled
      ;
    ungoogled-chromium = null;
    gnChromium = pkgs.buildPackages.gn.override upstream-info.deps.gn;
    apple-sdk = if hostPlatform.isDarwin then pkgs.apple-sdk_15 else null;
  }
  // linuxOnly
)
