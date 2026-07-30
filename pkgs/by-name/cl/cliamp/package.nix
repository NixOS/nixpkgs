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
  version = "1.62.0";

  src = fetchFromGitHub {
    owner = "bjarneo";
    repo = "cliamp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gGTSU4J3U9aojcfK9lE2qNDtye9N8WfJi0pIVk0ndJQ=";
  };

  vendorHash = "sha256-KYjP6qEINdSlcDSEMKxMwDfXzuQPAQSe4oZh+o4PrFs=";

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

  # macOS limits Unix socket paths to 104 bytes; use a shorter TMPDIR.
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export TMPDIR="$(mktemp -d /tmp/cliamp-XXXXXX)"
  '';

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
    platforms = with lib.platforms; darwin ++ linux;
    maintainers = with lib.maintainers; [ supermarin ];
    mainProgram = "cliamp";
  };
})
