{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  taglib,
  cglm,
  libclipboard,
  libxcb,
  makeWrapper,
  python3Packages,
  ffmpeg,
  yt-dlp,
  miniaudio,
  jq,
  glfw,
  exiftool,
  stb,
  libGL,
}:

stdenv.mkDerivation {
  name = "lyssa";
  version = "0-unstable-2024-06-01";

  src = fetchFromGitHub {
    owner = "cococry";
    repo = "lyssa";
    rev = "a7ebb786b005d9f716dfa99869e29660ca14c749";
    hash = "sha256-jJx7V/ru6quvZhqkVK3OGguH81882fQXNdpLVp+g5sk=";
  };

  buildInputs = [
    cglm
    libclipboard
    libxcb
    glfw
  ];
  nativeBuildInputs = [
    pkg-config
    taglib
    makeWrapper
  ];

  postFixup =
    let
      runtimeDeps = lib.makeBinPath [
        jq
        exiftool
        stb
        miniaudio
        yt-dlp
        ffmpeg
        python3Packages.glad
      ];
    in
    ''
      wrapProgram $out/bin/lyssa \
      --prefix PATH : ${runtimeDeps}
    '';

  installPhase = ''
    mkdir -p $out/{bin,share/{applications,icons}}


    install -Dm755 bin/lyssa -t $out/bin
    install -D Lyssa.desktop -t $out/share/applications
    mkdir -p $out/share/icons
    cp -r logo $out/share/icons/lyssa
  '';

  hardeningDisable = [ "all" ];

  meta = {
    description = "Music player designed to be an aesthetic addition for every desktop";
    homepage = "https://github.com/cococry/lyssa";
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "lyssa";
    platforms = lib.platforms.linux;
  };
}
