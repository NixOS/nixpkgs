{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "bsky-cli";
  version = "0.0.79";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "bsky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-id7+g9NMCSicPbDoDSqnc7OwEMIVXbXw3O8TkeQjfmg=";
  };

  vendorHash = "sha256-m4kth6r13++53fbceWjKYu4D297meAwnkaSsCiu5zS8=";

  buildInputs = [
    libpcap
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/bsky";
  nativeBuildInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cli application for bluesky social";
    homepage = "https://github.com/mattn/bsky";
    changelog = "https://github.com/mattn/bsky/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "bsky";
  };
})
