{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  makeWrapper,
  alsa-lib,
  libmpg123,
  libogg,
  libvorbis,
  ffmpeg,
  flac,
  yt-dlp,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cliamp";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "bjarneo";
    repo = "cliamp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-26wxzMd9Sidpk4Hmz+v0I31fFzoBvZCz25PCqcEMT40=";
  };

  vendorHash = "sha256-QKCuGXw/I3Gp0c0mXvL6GsON5FEa7m9yNE0tNGfGibg=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libmpg123
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
