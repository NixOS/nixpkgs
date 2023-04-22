{ lib, stdenv, fetchFromGitHub, libjpeg }:

stdenv.mkDerivation rec {
  version = "1.5.3";
  pname = "jpegoptim";

  src = fetchFromGitHub {
    owner = "tjko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vNjXY/Qz6IT7rV+as2EBkSWd4O98slcXLNgAO9Dkc9E=";
  };

  # There are no checks, it seems.
  doCheck = false;

  buildInputs = [ libjpeg ];

  meta = with lib; {
    description = "Optimize JPEG files";
    homepage = "https://www.kokkonen.net/tjko/projects.html";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.aristid ];
    platforms = platforms.all;
  };
}
