# The napi addon that renders preview and export. It is dlopen'd into Electron,
# whose bundled libffmpeg.so already owns the global ffmpeg symbols, so the addon
# links against copies of ffmpeg whose symbols are renamed with an osff_ prefix.
{
  lib,
  rustPlatform,
  symlinkJoin,
  pkg-config,
  rustfmt,
  patchelfUnstable,
  binutils,
  vulkan-loader,
  version,
  src,
  ffmpeg-lgpl,
}:
let
  ffmpegTree = symlinkJoin {
    name = "ffmpeg-lgpl-tree";
    paths = [
      ffmpeg-lgpl.dev
      ffmpeg-lgpl.lib
    ];
  };
in
rustPlatform.buildRustPackage {
  pname = "openscreen-compositor-view";
  inherit version src;
  sourceRoot = "${src.name}/crates";

  cargoHash = "sha256-Evn0dWd/1GOrFE0CM8bRMe/NRkniG6Ndj9oEeHxtHL8=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    # build.rs matches rustfmt-formatted bindgen output when it prefixes symbols.
    rustfmt
    pkg-config
    # --rename-dynamic-symbols needs patchelf >= 0.18.
    patchelfUnstable
    binutils
  ];
  buildInputs = [ ffmpeg-lgpl ];

  env.OPENSCREEN_FFMPEG_SYMBOL_PREFIX = "osff_";

  preBuild = ''
    stage=$NIX_BUILD_TOP/ffmpeg-renamed
    mkdir -p $stage/lib
    : > $NIX_BUILD_TOP/symnames
    for lib in ${ffmpeg-lgpl.lib}/lib/lib{avformat,avcodec,avutil,swscale,swresample,avfilter}.so.*; do
      case $lib in *.so.*.*) continue ;; esac
      cp "$(readlink -f $lib)" $stage/lib/$(basename $lib)
      nm -D --defined-only $lib | awk '{ n = $3; sub(/@.*/, "", n); if (n ~ /^(av|sws_|swr_)/) print n }' >> $NIX_BUILD_TOP/symnames
    done
    map=$NIX_BUILD_TOP/symbols.map
    sort -u $NIX_BUILD_TOP/symnames | awk '{ print $1 " osff_" $1 }' > $map
    test -s $map
    for so in $stage/lib/*.so.*; do
      chmod u+w $so
      patchelf --rename-dynamic-symbols $map $so
      ln -sf $(basename $so) $stage/lib/$(basename $so | sed 's/\.so\..*/.so/')
    done
    ln -s ${ffmpegTree}/include $stage/include
    export FFMPEG_DIR=$stage
  '';

  # The workspace also holds a Direct3D proof of concept.
  cargoBuildFlags = [
    "-p"
    "compositor-view-napi"
  ];
  # The test suite targets Windows.
  doCheck = false;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    find target -name libcompositor_view.so -path '*/release/*' -exec cp {} $out/lib/compositor_view.node \;
    test -f $out/lib/compositor_view.node
    cp $NIX_BUILD_TOP/ffmpeg-renamed/lib/*.so.* $out/lib/
    for so in $out/lib/*.so.*; do
      chmod u+w $so
      prev=$(patchelf --print-rpath $so)
      patchelf --set-rpath "\$ORIGIN''${prev:+:$prev}" $so
    done
    chmod u+w $out/lib/compositor_view.node
    patchelf --add-rpath '$ORIGIN' $out/lib/compositor_view.node

    leaked=$(nm -D --undefined-only $out/lib/compositor_view.node \
      | awk '{ n = $2; sub(/@.*/, "", n); if (n ~ /^(av|sws_|swr_)/ && n !~ /^osff_/) print n }')
    if [ -n "$leaked" ]; then
      echo "unprefixed ffmpeg imports left in the addon: $leaked" >&2
      exit 1
    fi
    runHook postInstall
  '';

  # wgpu dlopens libvulkan.so.1; added after fixupPhase's --shrink-rpath.
  postFixup = ''
    patchelf --force-rpath --add-rpath ${
      lib.makeLibraryPath [ vulkan-loader ]
    } $out/lib/compositor_view.node
  '';

  meta = {
    description = "Native compositor addon for OpenScreen";
    homepage = "https://github.com/getopenscreen/openscreen";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
