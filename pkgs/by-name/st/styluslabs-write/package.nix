{
  lib,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  SDL2,
  xorg,
  libGL,
  roboto,
  imagemagick,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "styluslabs-write";
  version = "2024-10-12";

  src = fetchFromGitHub {
    owner = "styluslabs";
    repo = "Write";
    rev = "b13572e2dd6a87af35cd3edde92c9144a6dd8a2b";
    hash = "sha256-cL6jU54LTkYu0mLNOgSDgChkDdg7eQaM00hTMas6cTg=";
    fetchSubmodules = true;
    leaveDotGit = true;
    # Delete .git folder for better reproducibility
    # TODO: fix GITCOUNT is always 1 but is not used in Linux Build anyway
    postFetch = ''
      cd $out
      git rev-parse --short HEAD > $out/GITREV
      git rev-list --count HEAD > $out/GITCOUNT
      rm -rf $out/.git
    '';
  };

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
    imagemagick # magick
    pkg-config
  ];

  buildInputs = [
    SDL2
    xorg.libX11
    xorg.libXi
    xorg.libXcursor
    libGL
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,opt}
    install -m555 -D syncscribble/Release/Write $out/opt/
    install -m444 -D scribbleres/Intro.svg $out/opt/
    install -m444 -D scribbleres/fonts/DroidSansFallback.ttf $out/opt/
    ln -s ${roboto}/share/fonts/truetype/Roboto-Regular.ttf $out/opt/Roboto-Regular.ttf

    ln -s ../opt/Write $out/bin/Write

    for i in 16 24 48 64 96 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      magick scribbleres/write_512.png -resize ''${i}x''${i} $out/share/icons/hicolor/''${i}x''${i}/apps/${finalAttrs.pname}.png
    done

    install -Dm444 scribbleres/linux/Write.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/Write.desktop \
        --replace-fail 'Exec=/opt/Write/Write' 'Exec=Write' \
        --replace-fail 'Icon=Write144x144' 'Icon=${finalAttrs.pname}'
  '';

  enableParallelBuilding = true;

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
