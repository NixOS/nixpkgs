{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargonode";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "xosnrdev";
    repo = "cargonode";
    rev = "refs/tags/${version}";
    hash = "sha256-xzBLuQRyKmd9k0sbBFV5amtFWwKqXR0CEsRv8SHiJcQ=";
  };

  cargoHash = "sha256-v+Fs2VJrpnIOk9nPRanYYChlR7WOfkXF1kbYOKjOUYc=";

  nativeBuildInputs = [
    pkg-config
  ];

  nativeCheckInputs = [
    git
  ];

  meta = {
    description = "Unified tooling for Node.js";
    mainProgram = "cargonode";
    homepage = "https://github.com/xosnrdev/cargonode";
    changelog = "https://github.com/xosnrdev/cargonode/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ xosnrdev ];
  };
}
