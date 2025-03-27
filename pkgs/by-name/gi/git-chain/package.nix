{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  git,
  nix-update-script,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage {
  pname = "git-chain";
  version = "0-unstable-2025-03-10";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "git-chain";
    rev = "d06b022b7bccf612fc5651c7ae119b37f69ac4ca";
    hash = "sha256-lfiwRJSzOlWdj9BfPfb/Vnd2NtzyK7HAHhERKFYOjM8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0Ur80eIKQIsM5vyIt+9YpFufHTk97+T+KXoAkJE90Ag=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
      ]
    );

  nativeCheckInputs = [ git ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = with lib; {
    description = "Tool for rebasing a chain of local git branches";
    homepage = "https://github.com/dashed/git-chain";
    license = licenses.mit;
    mainProgram = "git-chain";
    maintainers = with maintainers; [ bcyran ];
  };
}
