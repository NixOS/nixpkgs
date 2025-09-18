{
  apple-sdk_15,
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "jikken";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "jikkenio";
    repo = "jikken";
    rev = "v${version}";
    hash = "sha256-8A9b9Ms/unv+qQRd5jiTV/6SJa6ZYLsE0fK97ohacPI=";
  };

  cargoHash = "sha256-nwFTKol5phXFuDzAcnPoFq8UrrqMDE6NuitpXE5qJwU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(v\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = with lib; {
    description = "Powerful, source control friendly REST API testing toolkit";
    homepage = "https://jikken.io/";
    changelog = "https://github.com/jikkenio/jikken/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
    mainProgram = "jk";
  };
}
