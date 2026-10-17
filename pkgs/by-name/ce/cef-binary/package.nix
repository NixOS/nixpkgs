{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
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
  vulkan-loader,
  version ? "151.3.16",
  gitRevision ? "be1e15d",
  chromiumVersion ? "151.0.7922.109",
  buildType ? "Release",
  srcHashes ? {
    aarch64-linux = "sha256-gRYcEylZAUvKTOmV1zw9TyiEkv6FZ0vhVT1mLwne57k=";
    x86_64-linux = "sha256-6usxPmA53kZIVYk9KHxNXrTscSaXjqg8YWS/SiPcAXo=";
  },
}:

let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cef-binary";
  inherit version;

  src = fetchurl {
    url = "https://cef-builds.spotifycdn.com/${finalAttrs.passthru.cefDistName}.tar.bz2";
    hash = selectSystem srcHashes;
  };

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;

  stripAllList = [ "Release" ];

  dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
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
    vulkan-loader
    stdenv.cc.cc
  ];

  postPatch = ''
    sed 's/-O0/-O2/' -i cmake/cef_variables.cmake
  '';

  installPhase = ''
    runHook preInstall

    cp --recursive . $out

    runHook postInstall
  '';

  postFixup = ''
    patchelf --add-needed libudev.so "$out/${buildType}/libcef.so"
    patchelf --add-needed libGL.so.1 "$out/${buildType}/libGLESv2.so"

    # Unvendor vulkan-loader
    rm "$out/${buildType}/libvulkan.so.1"
    ln -s -t "$out/${buildType}" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"
    # ANGLE (libEGL/libGLESv2) and SwiftShader (libvk_swiftshader) have ABIs that
    # change over time, so we have to rely on the vendored version
  '';

  passthru = {
    inherit buildType gitRevision chromiumVersion;
    cefPlatform = selectSystem {
      x86_64-linux = "linux64";
      aarch64-linux = "linuxarm64";
    };
    cefFullVersion = "${version}+g${gitRevision}+chromium-${chromiumVersion}";
    cefDistName = "cef_binary_${finalAttrs.passthru.cefFullVersion}_${finalAttrs.passthru.cefPlatform}_minimal";
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
})
