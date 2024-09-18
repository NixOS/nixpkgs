{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "jsoncons";
  version = "0.176.0";

  src = fetchFromGitHub {
    owner = "danielaparker";
    repo = "jsoncons";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RDF5HL6utM/6wna1TxCefl7X8B1qp6nsEDrguTLrtgA=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "C++, header-only library for constructing JSON and JSON-like data formats";
    homepage = "https://danielaparker.github.io/jsoncons/";
    changelog = "https://github.com/danielaparker/jsoncons/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.boost;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
  };
})
