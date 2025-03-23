{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "anubis";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "TecharoHQ";
    repo = "anubis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K4VXTO8F3GTOA9jOrI0OF6CYTRaDUlUT9/HujYmnHpM=";
  };

  vendorHash = "sha256-t+E3sILEwXGkTaBtKLO2kFEntivY9fVK8o86arvMaOU=";

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
    maintainers = with lib.maintainers; [ knightpp ];
    mainProgram = "anubis";
  };
})
