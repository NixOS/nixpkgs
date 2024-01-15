{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, fontconfig
, freetype
}:
let
  inherit (rustPlatform) buildRustPackage bindgenHook;

  version = "0.2.8";
in
buildRustPackage {
  pname = "figma-agent";
  inherit version;

  src = fetchFromGitHub {
    owner = "neetly";
    repo = "figma-agent-linux";
    rev = version;
    sha256 = "sha256-GtbONBAXoJ3AdpsWGk4zBCtGQr446siMtuj3or27wYw=";
  };

  cargoHash = "sha256-EmBeRdnA59PdzSEX2x+sVYk/Cs7K3k0idDjbuEzI9j4=";

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
  };
}
