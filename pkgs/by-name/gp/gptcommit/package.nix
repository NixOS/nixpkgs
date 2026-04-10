{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  nix-update-script,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gptcommit";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "zurawiki";
    repo = "gptcommit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gMu59i/Gx6NINMnX2OMHjOsRnz6mE13dEci8YJFlm+M=";
  };

  cargoHash = "sha256-t+rlUBUndj1iM4Y7K03zfDEOC5Z0KEWcOcurv5SKJ3c=";

  nativeBuildInputs = [ pkg-config ];

  # 0.5.6 release has failing tests
  doCheck = false;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Git prepare-commit-msg hook for authoring commit messages with GPT-3";
    mainProgram = "gptcommit";
    homepage = "https://github.com/zurawiki/gptcommit";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = with lib.platforms; all;
  };
})
