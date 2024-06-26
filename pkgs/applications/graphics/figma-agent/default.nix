{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, fontconfig
, freetype
}:
let
  inherit (rustPlatform) buildRustPackage bindgenHook;

  version = "0.3.2";
in
buildRustPackage {
  pname = "figma-agent";
  inherit version;

  src = fetchFromGitHub {
    owner = "neetly";
    repo = "figma-agent-linux";
    rev = version;
    sha256 = "sha256-iXLQOc8gomOik+HIIoviw19II5MD6FM0W5DT3aqtIcM=";
  };

  cargoHash = "sha256-ulYDKMMtKfBYur34CVhac4uaU0kfdkeBCCP/heuUZek=";

  nativeBuildInputs = [
    pkg-config
    bindgenHook
  ];

  buildInputs = [
    fontconfig
    freetype
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/neetly/figma-agent-linux";
    description = "Figma Agent for Linux (a.k.a. Font Helper)";
    license = licenses.mit;
    maintainers = with maintainers; [ ercao ];
    mainProgram = "figma-agent";
  };
}
