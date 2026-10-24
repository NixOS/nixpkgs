{
  stdenv,
  fetchurl,
  vulkan-headers,
  prebuilt,
  deskportSource,
}:
# Backport FFmpeg's Vulkan lifetime fixes without upgrading media dependencies.
# Rebuild only the four affected translation units with the shipped config.
stdenv.mkDerivation {
  pname = "deskport-ffmpeg-vulkan-cbs";
  version = "fb216b5-b672ae39";
  src = fetchurl {
    url = "https://codeload.github.com/FFmpeg/FFmpeg/tar.gz/fb216b5facde2c97cb0ce2e75fb3228aa5ac21fa";
    hash = "sha256-0ZSApY+GztaRPEHx9v7WnvRTg1KdHzSFQTRPMBrmcWU=";
  };
  patches = [
    "${deskportSource}/host/linux/ffmpeg-vulkan-cbs.patch"
    "${deskportSource}/host/linux/ffmpeg-vulkan-queued-views.patch"
    "${deskportSource}/host/linux/ffmpeg-vulkan-feedback.patch"
  ];
  unpackPhase = ''
    runHook preUnpack
    mkdir source
    tar -xzf "$src" --strip-components=1 -C source
    cd source
    runHook postUnpack
  '';
  dontConfigure = true;
  dontFixup = true;
  buildPhase = ''
    runHook preBuild
    grep -Fx '#define FFMPEG_VERSION "fb216b5"' ${prebuilt}/include/libavutil/ffversion.h
    # Fail on an ABI/header mismatch instead of mixing unrelated builds.
    for header in libavcodec/avcodec.h libavcodec/codec.h libavutil/hwcontext_vulkan.h; do
      cmp "$header" "${prebuilt}/include/$header"
    done
    cp ${prebuilt}/include/config.h config.h
    cp ${prebuilt}/include/libavutil/avconfig.h libavutil/avconfig.h
    for unit in vulkan_encode vulkan_encode_h264 vulkan_encode_h265 vulkan_encode_av1; do
      $CC -O2 -fPIC -I. -I${prebuilt}/include -I${vulkan-headers}/include \
        -c "libavcodec/$unit.c" -o "$unit.o"
    done
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    cp -R ${prebuilt} "$out"
    chmod -R u+w "$out"
    for unit in vulkan_encode vulkan_encode_h264 vulkan_encode_h265 vulkan_encode_av1; do
      test "$($AR t "$out/lib/libavcodec.a" | grep -cx "$unit.o")" = 1
      $AR r "$out/lib/libavcodec.a" "$unit.o"
    done
    $RANLIB "$out/lib/libavcodec.a"
    runHook postInstall
  '';
}
