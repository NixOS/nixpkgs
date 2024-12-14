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
  version = "0-unstable-2024-11-16";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "git-chain";
    rev = "90165393a9e78b1e0837b8ad0c6acd8b1253731a";
    hash = "sha256-hRBymc4wmmniD4IwmgxSw1EIkT6omoqdrnwr+Eaa/yg=";
  };

  cargoHash = "sha256-nx7HRQd9HD9OcK41XiaC4m52atTWTPeGFVX7df2wv+0=";

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
