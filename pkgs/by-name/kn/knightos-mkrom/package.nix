{ lib, stdenv, fetchFromGitHub, libxslt, asciidoc }:

stdenv.mkDerivation rec {
  pname = "mkrom";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "mkrom";
    rev = version;
    sha256 = "sha256-YFrh0tOGiM90uvU9ZWopW1+9buHDQtetuOtPDSYYaXw=";
  };

  strictDeps = true;
  nativeBuildInputs = [ asciidoc libxslt.bin ];

  installFlags = [ "DESTDIR=$(out)" ];
  installTargets = [ "install" "install_man" ];

  meta = with lib; {
    homepage    = "https://knightos.org/";
    description = "Packages KnightOS distribution files into a ROM";
    mainProgram = "mkrom";
    license     = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms   = platforms.all;
  };
}
