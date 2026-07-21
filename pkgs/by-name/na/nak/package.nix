{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  fuse,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nak";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "fiatjaf";
    repo = "nak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QP2r+Eq0O9cRyF3NLT6s8L1CZqfiRdJ2O+nDfvrO5iI=";
  };

  vendorHash = "sha256-uftDwPMu2pK5wEfMrO6HSRFcvcr+Cst3uQ8cpOMESs4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fuse
  ];

  # Integration tests fail (requires connection to relays)
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for Nostr things";
    homepage = "https://github.com/fiatjaf/nak";
    changelog = "https://github.com/fiatjaf/nak/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "nak";
  };
})
