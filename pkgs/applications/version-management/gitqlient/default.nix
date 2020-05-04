{ stdenv, mkDerivation, fetchFromGitHub
, qtbase, qmake
}:

with stdenv.lib;

mkDerivation rec {
  pname = "GitQlient";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "francescmm";
    repo = "GitQlient";
    rev = "v${version}";
    sha256 = "048mmwx0nv7sb2cpwl1h8wqb4q7dcnkrrmhvq08yznylgdcgkgs1";
    fetchSubmodules = true;
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ qmake ];
  installFlags = [ "INSTALL_ROOT=$(out)" ];

  postInstall = ''
    mv $out/homeless-shelter/GitQlient/bin $out/bin
  '';

  meta = {
    homepage = "https://github.com/francescmm/GitQlient";
    description = "GitQlient: Multi-platform Git client written with Qt";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
