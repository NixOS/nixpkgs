{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, fontconfig
, freetype
, libclang
}:
let
  inherit (rustPlatform) buildRustPackage bindgenHook;

  version = "0.2.7";
in
buildRustPackage {
  pname = "figma-agent";
  inherit version;

  src = fetchFromGitHub {
    owner = "neetly";
    repo = "figma-agent-linux";
    rev = version;
    sha256 = "sha256-Cq1hWNwJLBY9Bb41WFJxnr9fcygFZ8eNsn5cPXmGTyw=";
  };

  cargoSha256 = "sha256-Gc94Uk/Ikxjnb541flQL7AeblgU/yS6zQ/187ZGRYco=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    freetype
    bindgenHook
  ];

  LIBCLANG_PATH = "${libclang.lib}/lib";

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/neetly/figma-agent-linux";
    description = "Figma Agent for Linux (a.k.a. Font Helper)";
    license = licenses.mit;
    maintainers = with maintainers; [ ercao ];
  };
}
