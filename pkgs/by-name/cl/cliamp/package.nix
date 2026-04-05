{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
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
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "bjarneo";
    repo = "cliamp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0WT3DRII4o58KFK+7UW0QgrJwrJwmPkKmTQeVXmtoZ0=";
  };

  vendorHash = "sha256-+uh+4ZYvnlKmRSIvZFlnfBPqU0CFFe/Op1Gr9hjIr4U=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libogg
    libvorbis
    flac
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
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

  # this is set due to failure of testset `net/http/httptest` on darwin
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal Winamp - a retro terminal music player inspired by Winamp 2.x";
    homepage = "https://github.com/bjarneo/cliamp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ supermarin ];
    mainProgram = "cliamp";
  };
})
