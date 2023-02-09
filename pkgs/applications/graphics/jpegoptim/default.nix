{ lib, stdenv, fetchFromGitHub, libjpeg }:

stdenv.mkDerivation rec {
  version = "1.5.1";
  pname = "jpegoptim";

  src = fetchFromGitHub {
    owner = "tjko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QPipwBk+BS/u3YxB8ACeFXQSuoW1aynEyG3tEMrhcaE=";
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
