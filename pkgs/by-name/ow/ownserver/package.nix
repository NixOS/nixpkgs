{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ownserver";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Kumassy";
    repo = "ownserver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bseDssSMerBlzlCvL3rD3X6ku5qDRYvI1wxq2W7As5k=";
  };

  cargoHash = "sha256-SJm66CDrg6ZpIeKx27AnZAVs/Z25E/KmHYuZ9G4UwHQ=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Expose your local game server to the Internet";
    homepage = "https://github.com/Kumassy/ownserver";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jaredmontoya ];
    mainProgram = "ownserver";
  };
})
