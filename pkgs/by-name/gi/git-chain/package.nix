{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  git,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "git-chain";
  version = "0-unstable-2025-03-25";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "git-chain";
    rev = "f6a6d365e6e3cce15e74649a421044a01fb4f68f";
    hash = "sha256-lOAURUhR2Ts1DF8yW0WnovSWeZFC8UwR6j4cxoreonY=";
  };

  cargoHash = "sha256-0Ur80eIKQIsM5vyIt+9YpFufHTk97+T+KXoAkJE90Ag=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

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
