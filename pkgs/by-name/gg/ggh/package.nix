{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ggh";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "byawitz";
    repo = "ggh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-itNx/AcLUQCH99ZCOXiXPWNg3mx+UhHepidqmzPY8Oc=";
  };

  vendorHash = "sha256-WPPjpxCD3WA3E7lx5+DPvG31p8djera5xRn980eaJT8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Recall your SSH sessions (also search your SSH config file)";
    homepage = "https://github.com/byawitz/ggh";
    changelog = "https://github.com/byawitz/ggh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ilarvne ];
    platforms = lib.platforms.unix;
    mainProgram = "ggh";
  };
})
