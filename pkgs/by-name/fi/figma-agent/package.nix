{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  fontconfig,
  freetype,
}:
rustPlatform.buildRustPackage rec {
  pname = "figma-agent";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "neetly";
    repo = "figma-agent-linux";
    rev = "refs/tags/${version}";
    sha256 = "sha256-iXLQOc8gomOik+HIIoviw19II5MD6FM0W5DT3aqtIcM=";
  };

  cargoHash = "sha256-ulYDKMMtKfBYur34CVhac4uaU0kfdkeBCCP/heuUZek=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    freetype
  ];

  meta = {
    homepage = "https://github.com/neetly/figma-agent-linux";
    description = "Figma Agent for Linux (a.k.a. Font Helper)";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ercao ];
    mainProgram = "figma-agent";
  };
}
