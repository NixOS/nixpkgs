{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "anubis";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "TecharoHQ";
    repo = "anubis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PlZEGe3kTBkTd17nTLSW6pGiUKIPVQttep92FT+10g8=";
  };

  vendorHash = "sha256-Rcra5cu7zxGm2LhL2x9Kd3j/uQaEb8OOh/j5Rhh8S1k=";

  subPackages = [
    "cmd/anubis"
  ];

  ldflags =
    [
      "-s"
      "-w"
      "-X=github.com/TecharoHQ/anubis.Version=v${finalAttrs.version}"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "-extldflags=-static"
    ];

  preCheck = ''
    export DONT_USE_NETWORK=1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Weighs the soul of incoming HTTP requests using proof-of-work to stop AI crawlers";
    homepage = "https://github.com/TecharoHQ/anubis/";
    changelog = "https://github.com/TecharoHQ/anubis/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      knightpp
      soopyc
    ];
    mainProgram = "anubis";
  };
})
