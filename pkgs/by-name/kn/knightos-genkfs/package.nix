{ lib, stdenv, fetchFromGitHub, asciidoc, cmake, libxslt }:

stdenv.mkDerivation rec {
  pname = "genkfs";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "genkfs";
    rev = version;
    sha256 = "0f50idd2bb73b05qjmwlirjnhr1bp43zhrgy6z949ab9a7hgaydp";
  };

  strictDeps = true;

  nativeBuildInputs = [ asciidoc libxslt.bin cmake ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage    = "https://knightos.org/";
    description = "Utility to write a KFS filesystem into a ROM file";
    mainProgram = "genkfs";
    license     = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms   = platforms.all;
  };
}
