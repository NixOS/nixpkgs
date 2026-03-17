{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  alsa-lib,
  libogg,
  libvorbis,
  ffmpeg,
  flac,
  yt-dlp,
}:

buildGoModule (finalAttrs: {
  pname = "cliamp";
  version = "1.21.2";

  src = fetchFromGitHub {
    owner = "bjarneo";
    repo = "cliamp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bu1x6Kg8LUiNaD8BP7HTGlnBXLMhn5y6KkWoxWYyukw=";
  };

  vendorHash = "sha256-UMDCpfSGfvJmI+sImaFzgZpLNaLMgEnmGCqERwPokHM=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    libogg
    libvorbis
    flac
  ];

  postInstall = ''
    wrapProgram $out/bin/cliamp \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          yt-dlp
        ]
      }
  '';

  meta = {
    description = "Terminal Winamp - a retro terminal music player inspired by Winamp 2.x";
    homepage = "https://github.com/bjarneo/cliamp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ supermarin ];
    mainProgram = "cliamp";
  };
})
