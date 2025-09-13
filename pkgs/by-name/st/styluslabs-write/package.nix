{
  lib,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  SDL2,
  xorg,
  libGL,
  roboto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "styluslabs-write";
  version = "2025-01-10";

  src = fetchFromGitHub {
    owner = "styluslabs";
    repo = "Write";
    rev = "0924f8fb7b9b211b7309b8324e1aef2950df1c6a";
    hash = "sha256-7QPpAhzDaDvx747dW+poj3ulVa7RPl5Z7esIad2YjfY=";
    fetchSubmodules = true;
  };

  hardeningDisable = [ "format" ];
  makeFlags = [
    "DEBUG=0"
    "USE_SYSTEM_SDL=1"
    "GITREV=${lib.substring 0 7 finalAttrs.src.rev}"
    # The following line is matched with regex in update.rb.
    "GITCOUNT=14"
  ];
  preBuild = ''
    pushd syncscribble
  '';
  postBuild = ''
    popd
  '';

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    SDL2
    xorg.libX11
    xorg.libXi
    xorg.libXcursor
    libGL
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,opt/Write}
    install -Dm755 syncscribble/Release/Write -t $out/opt/Write
    install -Dm644 scribbleres/Intro.svg -t $out/opt/Write
    install -Dm644 scribbleres/fonts/DroidSansFallback.ttf -t $out/opt/Write
    ln -s ${roboto}/share/fonts/truetype/Roboto-Regular.ttf -t $out/opt/Write

    ln -s ../opt/Write/Write $out/bin/Write

    mkdir -p $out/share/icons/hicolor/512x512/apps
    install -Dm644 scribbleres/write_512.png $out/share/icons/hicolor/512x512/apps/styluslabs-write.png

    install -Dm644 scribbleres/linux/Write.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/Write.desktop \
      --replace-fail 'Exec=/opt/Write/Write' 'Exec=Write' \
      --replace-fail 'Icon=Write144x144' 'Icon=styluslabs-write'
  '';

  enableParallelBuilding = true;

  passthru.updateScript = ./update.rb;

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
