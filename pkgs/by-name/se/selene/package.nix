{
  lib,
  rustPlatform,
  fetchFromGitHub,
  robloxSupport ? true,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "selene";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = "selene";
    rev = version;
    sha256 = "sha256-/KMLOZtCdvv76BDGj1oM6Q93cX6yPE4E5ZM+Xy6yRxA=";
  };

  cargoHash = "sha256-RlD4CbLJpmOSQJCMaXFC7/83qlPpnzd2wBn3xNu1yQ0=";

  nativeBuildInputs = lib.optionals robloxSupport [
    pkg-config
  ];

  buildInputs = lib.optionals robloxSupport [
    openssl
  ];

  buildNoDefaultFeatures = !robloxSupport;

  meta = {
    description = "Blazing-fast modern Lua linter written in Rust";
    mainProgram = "selene";
    homepage = "https://github.com/kampfkarren/selene";
    changelog = "https://github.com/kampfkarren/selene/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
