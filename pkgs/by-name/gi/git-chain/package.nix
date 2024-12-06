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
  version = "0-unstable-2024-08-09";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "git-chain";
    rev = "4fee033ea1ee51bbb6b7f75411f0f4f799aea1e2";
    hash = "sha256-wQZXixg7mCBUo18z/WCkTWW3R0j2jxs8t1yaQzY3Eu4=";
  };

  cargoHash = "sha256-pRxOrlDgfSpUBY2WKfoIH9ngLzb2noiLqxA3/6s+mRw=";

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
