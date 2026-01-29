{
  lib,
  stdenv,
  fetchurl,
  glib,
  nss,
  nspr,
  atk,
  at-spi2-atk,
  libdrm,
  expat,
  libxkbcommon,
  libgbm,
  gtk3,
  pango,
  cairo,
  alsa-lib,
  dbus,
  at-spi2-core,
  cups,
  libGL,
  udev,
  systemdLibs,
  libxrandr,
  libxfixes,
  libxext,
  libxdamage,
  libxcomposite,
  libx11,
  libxshmfence,
  libxcb,
  version ? "144.0.11",
  gitRevision ? "e135be2",
  chromiumVersion ? "144.0.7559.97",
  buildType ? "Release",
  srcHashes ? {
    aarch64-linux = "sha256-aMgl6i9k33H1cq2ubFKOfsxauTrF8TvJg5qxf2wwmwY=";
    x86_64-linux = "sha256-almKJ18g//Wi2CDRX1yibODvR6TF0DlUl1EnDNlIHBY=";
  },
}:

let
  gl_rpath = lib.makeLibraryPath [ stdenv.cc.cc ];

  rpath = lib.makeLibraryPath [
    glib
    nss
    nspr
    atk
    at-spi2-atk
    libdrm
    expat
    libxkbcommon
    libgbm
    gtk3
    pango
    cairo
    alsa-lib
    dbus
    at-spi2-core
    cups
    libGL
    udev
    systemdLibs
    libxcb
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxshmfence
  ];

  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "cef-binary";
  inherit version;

  src = fetchurl {
    url = "https://cef-builds.spotifycdn.com/cef_binary_${version}+g${gitRevision}+chromium-${chromiumVersion}_${
      selectSystem {
        aarch64-linux = "linuxarm64";
        x86_64-linux = "linux64";
      }
    }_minimal.tar.bz2";
    hash = selectSystem srcHashes;
  };

  dontStrip = true;

  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    sed 's/-O0/-O2/' -i cmake/cef_variables.cmake
    patchelf --set-rpath "${rpath}" --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" ${buildType}/chrome-sandbox
    patchelf --add-needed libudev.so --set-rpath "${rpath}" ${buildType}/libcef.so
    patchelf --set-rpath "${gl_rpath}" ${buildType}/libEGL.so
    patchelf --add-needed libGL.so.1 --set-rpath "${gl_rpath}" ${buildType}/libGLESv2.so
    patchelf --set-rpath "${gl_rpath}" ${buildType}/libvk_swiftshader.so
    patchelf --set-rpath "${gl_rpath}" ${buildType}/libvulkan.so.1
    cp --recursive . $out

    runHook postInstall
  '';

  passthru = {
    inherit buildType;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Simple framework for embedding Chromium-based browsers in other applications";
    homepage = "https://cef-builds.spotifycdn.com/index.html";
    maintainers = with lib.maintainers; [ puffnfresh ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.bsd3;
    platforms = builtins.attrNames srcHashes;
  };
}
