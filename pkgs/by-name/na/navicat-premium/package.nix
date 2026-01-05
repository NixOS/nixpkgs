{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  autoPatchelfHook,
  qt6,
  cjson,
  curl,
  e2fsprogs,
  expat,
  fontconfig,
  freetype,
  glib,
  glibc,
  harfbuzz,
  libGL,
  libX11,
  libgpg-error,
  libselinux,
  libxcb,
  libxcrypt,
  libxcrypt-legacy,
  libxkbcommon,
  p11-kit,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "navicat-premium";
  version = "17.3.3";

  src = appimageTools.extractType2 {
    inherit (finalAttrs) pname version;
    src =
      {
        x86_64-linux = fetchurl {
          url = "https://web.archive.org/web/20251008050849/https://dn.navicat.com/download/navicat17-premium-en-x86_64.AppImage";
          hash = "sha256-gXXj2FXOw2OHUTaX5XYtd0/nL/E/hNmcmvc0TDaOCUQ=";
        };
        aarch64-linux = fetchurl {
          url = "https://web.archive.org/web/20251008051000/https://dn.navicat.com/download/navicat17-premium-en-aarch64.AppImage";
          hash = "sha256-18JbUJV8jAXRiVVerfYZLsjy+5K2DjwqAY+Hqjtlnfg=";
        };
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    cjson
    curl
    e2fsprogs
    expat
    fontconfig
    freetype
    glib
    glibc
    harfbuzz
    libGL
    libX11
    libgpg-error
    libselinux
    libxcb
    libxcrypt
    libxcrypt-legacy
    libxkbcommon
    p11-kit
    pango
    qt6.qtbase
  ];

  installPhase = ''
    runHook preInstall

    cp -r --no-preserve=mode usr $out
    chmod +x $out/bin/navicat
    mkdir -p $out/usr
    ln -s $out/lib $out/usr/lib

    runHook postInstall
  '';

  autoPatchelfIgnoreMissingDeps = lib.optionals stdenv.hostPlatform.isAarch64 [
    "libgs_ktool.so"
    "libkmc.so"
  ];

  dontWrapQtApps = true;

  preFixup = ''
    rm $out/lib/libselinux.so.1
    ln -s ${libselinux.out}/lib/libselinux.so.1 $out/lib/libselinux.so.1
    rm $out/lib/glib/libglib-2.0.so.0
    ln -s ${glib.out}/lib/libglib-2.0.so.0 $out/lib/glib/libglib-2.0.so.0
    patchelf --replace-needed libcrypt.so.1 \
      ${libxcrypt}/lib/libcrypt.so.2 $out/lib/pq-g/libpq.so.5.5
    patchelf --replace-needed libcrypt.so.1 \
      ${libxcrypt}/lib/libcrypt.so.2 $out/lib/pq-g/libpq_ce.so.5.5
    patchelf --replace-needed libselinux.so.1 \
      ${libselinux.out}/lib/libselinux.so.1 $out/lib/pq-g/libpq.so.5.5
    wrapQtApp $out/bin/navicat \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          e2fsprogs
          expat
          fontconfig
          freetype
          glib
          glibc
          harfbuzz
          libGL
          libX11
          libgpg-error
          libselinux
          libxcb
          libxkbcommon
          p11-kit
          pango
        ]
      }:$out/lib \
      --set QT_PLUGIN_PATH $out/plugins \
      --set QT_QPA_PLATFORM xcb \
      --set QT_STYLE_OVERRIDE Fusion \
      --chdir $out
  '';

  meta = {
    homepage = "https://www.navicat.com/products/navicat-premium";
    changelog = "https://www.navicat.com/products/navicat-premium-release-note";
    description = "Database development tool that allows you to simultaneously connect to many databases";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "navicat-premium";
  };
})
