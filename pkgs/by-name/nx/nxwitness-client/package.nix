{
  stdenv,
  lib,
  autoPatchelfHook,
  buildFHSEnv,
  dpkg,
  fetchurl,
  glib,
  gst_all_1,
  libGL,
  libgudev,
  libudev-zero,
  libxcb,
  libxkbfile,
  libxml2,
  libxslt,
  openal,
  qt6Packages,
  wayland,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  xcbutilwm,
}:
let
  version = "6.0.3";
  build = "40736";

  libxml2_13 = libxml2.overrideAttrs (oldAttrs: rec {
    version = "2.13.8";
    src = fetchurl {
      url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
      hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
    };
    meta = oldAttrs.meta // {
      knownVulnerabilities = oldAttrs.meta.knownVulnerabilities or [ ] ++ [
        "CVE-2025-6021"
      ];
    };
  });

  buildInputs = [
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libGL
    libgudev
    libudev-zero
    libxcb
    libxkbfile
    libxml2_13
    libxslt
    openal
    qt6Packages.qtbase
    qt6Packages.qtquicktimeline
    qt6Packages.qtwayland
    qt6Packages.qtwebengine
    qt6Packages.qtwebsockets
    qt6Packages.qtwebview
    wayland
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
  ];

  meta = {
    description = "Desktop Client for Nx Witness Video Systems";
    homepage = "https://nxvms.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ netali ];
    platforms = [ "x86_64-linux" ];
  };

  nxwitness_client = stdenv.mkDerivation (finalAttrs: {
    inherit buildInputs meta;
    pname = "nxwitness-client";
    version = "${version}.${build}";

    src = fetchurl {
      url = "https://updates.networkoptix.com/default/${build}/linux/nxwitness-client-${finalAttrs.version}-linux_x64.deb";
      hash = "sha256-flOTNKklovpvtFDWE64clL3Jk1cmT4SVgs1NQZZaXpc=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
    ];

    dontUnpack = true;
    dontWrapQtApps = true;

    installPhase = ''
      dpkg -x $src $out
      rm -r $out/usr
      mv $out/opt/networkoptix/client/${finalAttrs.version}/* $out/
      rm -r $out/opt

      # remove as many vendored libs as we can
      rm $out/lib/libgst*
      rm $out/lib/libxkb*
      rm $out/lib/libxcb*
      rm $out/lib/libhidapi*
      rm $out/lib/libopenal*
      rm $out/lib/libXss*
      rm -r $out/lib/stdcpp
      rm -r $out/lib/opengl
      rm -r $out/lib/libva-drivers
    '';
  });
in
# only runs in an FHS env for some reason
buildFHSEnv {
  inherit (nxwitness_client) pname version meta;
  targetPkgs = (
    pkgs:
    [
      nxwitness_client
    ]
    ++ buildInputs
  );
  runScript = "nxwitness_client";
}
