{ lib, stdenv, fetchFromGitHub, libjpeg }:

stdenv.mkDerivation rec {
  version = "1.5.0";
  pname = "jpegoptim";

  src = fetchFromGitHub {
    owner = "tjko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fTtNDjswxHv2kHU55RCzz9tdlXw+RUCSoe3qF4hQ7u4=";
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
