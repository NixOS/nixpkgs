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
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cliamp";
  version = "1.63.2";

  src = fetchFromGitHub {
    owner = "bjarneo";
    repo = "cliamp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HqFDT8jGvrKqb6bupvXqZ5ECpvColRB5dXPwcKCX4RQ=";
  };

  vendorHash = "sha256-WYyv0w5KFA15axb+NA9tClfc1H4Znj8kI2boR8XziXg=";

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
