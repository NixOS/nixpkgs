{
  lib,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  SDL2,
  libxi,
  libxcursor,
  libx11,
  libGL,
  roboto,
  imagemagick,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "styluslabs-write";
  version = "2025-01-10";

  src = fetchFromGitHub {
    owner = "styluslabs";
    repo = "Write";
    rev = "0924f8fb7b9b211b7309b8324e1aef2950df1c6a";
    hash = "sha256-aSgBcNRFGSoZlKCAX/uHvByPIkiXYKmBGR4j0k+eabs=";
    fetchSubmodules = true;
    deepClone = true;
    postFetch = ''
      git --git-dir=$out/.git rev-parse --short HEAD > $out/GITREV
      git --git-dir=$out/.git rev-list --count HEAD > $out/GITCOUNT
      rm -rf $out/.git
    '';
  };

  postPatch = ''
    # Fix GCC 14 build due to missing <cstdint> include.
    sed -e '3i #include <cstdint>' -i usvg/svgnode.h
  '';

  hardeningDisable = [ "format" ];
  makeFlags = [
    "DEBUG=0"
    "USE_SYSTEM_SDL=1"
  ];
  preBuild = ''
    makeFlagsArray+=(
      "GITREV=$(cat ./GITREV)"
      "GITCOUNT=$(cat ./GITCOUNT)"
    )
    pushd syncscribble
  '';
  postBuild = ''
    popd
  '';

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    imagemagick
  ];

  buildInputs = [
    SDL2
    libx11
    libxi
    libxcursor
    libGL
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,opt/Write}
    install -Dm555 syncscribble/Release/Write -t $out/opt/Write
    install -Dm444 scribbleres/Intro.svg -t $out/opt/Write
    install -Dm444 scribbleres/fonts/DroidSansFallback.ttf -t $out/opt/Write
    install -Dm444 ${roboto}/share/fonts/truetype/Roboto-Regular.ttf -t $out/opt/Write

    ln -s ../opt/Write/Write $out/bin/Write

    for width in 16 32 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${width}x$width/apps
      magick scribbleres/write_512.png -resize ''${width}x$width $out/share/icons/hicolor/''${width}x$width/apps/styluslabs-write.png
    done

    install -Dm444 scribbleres/linux/Write.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/Write.desktop \
      --replace-fail 'Exec=/opt/Write/Write' 'Exec=Write' \
      --replace-fail 'Icon=Write144x144' 'Icon=styluslabs-write'
  '';

  enableParallelBuilding = true;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://styluslabs.com/";
    description = "Cross-platform (Windows, Mac, Linux, iOS, Android) application for handwritten notes";
    license = with lib.licenses; [
      # miniz, pugixml, stb, ugui, ulib, usvg
      mit
      # nanovgXC
      zlib
      # styluslabs-write itself
      agpl3Only
    ];
    maintainers = with lib.maintainers; [
      lukts30
      atemu
    ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    broken = !stdenv.hostPlatform.isLinux;
    mainProgram = "Write";
  };
})
