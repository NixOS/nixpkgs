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
  version ? "142.0.10",
  gitRevision ? "29548e2",
  chromiumVersion ? "142.0.7444.135",
  buildType ? "Release",
  srcHashes ? {
    aarch64-linux = "sha256-wUCXk5Nqgzu0q0PvV8a2AKF3h4YxxTeaP2yVecrf0j8=";
    aarch64-darwin = "sha256-7vEhqsXSQtlZN3Ky0ZYo8vAlpeXAZAP4lgdFe90/UQA=";
    x86_64-linux = "sha256-pFMHjj4MktjnX3g03sgLqgai4X/lF29Phmduf7a+KfM=";
    #TODO: 26.11: remove the support for x86_64-darwin for more info please see: https://github.com/NixOS/nixpkgs/pull/492160
    x86_64-darwin = "sha256-zYltcWgv56xo8PNfg17Ayp0+bdJUW18co1aze2ytry8=";
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
stdenv.mkDerivation (finalAttrs: {
  pname = "cef-binary";
  inherit version;

  src = fetchurl {
    url = "https://cef-builds.spotifycdn.com/cef_binary_${version}+g${gitRevision}+chromium-${chromiumVersion}_${
      selectSystem {
        aarch64-linux = "linuxarm64";
        aarch64-darwin = "macosarm64";
        x86_64-linux = "linux64";
        #TODO: 26.11: remove the support for x86_64-darwin for more info please see: https://github.com/NixOS/nixpkgs/pull/492160
        x86_64-darwin = "macosx64";
      }
    }_minimal.tar.bz2";
    hash = selectSystem srcHashes;
  };

  dontStrip = true;

  dontPatchELF = true;

  patchLibs =
    if stdenv.hostPlatform.isLinux then
      ''
        patchelf --set-rpath "${rpath}" --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" ${buildType}/chrome-sandbox
        patchelf --add-needed libudev.so --set-rpath "${rpath}" ${buildType}/libcef.so
        patchelf --set-rpath "${gl_rpath}" ${buildType}/libEGL.so
        patchelf --add-needed libGL.so.1 --set-rpath "${gl_rpath}" ${buildType}/libGLESv2.so
        patchelf --set-rpath "${gl_rpath}" ${buildType}/libvk_swiftshader.so
        patchelf --set-rpath "${gl_rpath}" ${buildType}/libvulkan.so.1
      ''
    else
      "";

  installPhase = ''
    runHook preInstall

    sed 's/-O0/-O2/' -i cmake/cef_variables.cmake
    ${finalAttrs.patchLibs}
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
    maintainers = with lib.maintainers; [
      puffnfresh
      eveeifyeve # Darwin
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.bsd3;
    platforms = builtins.attrNames srcHashes;
  };
})
