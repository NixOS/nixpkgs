{
  lib,
  stdenv,
  fetchFromGitHub,
  libjpeg,
}:

stdenv.mkDerivation rec {
  version = "1.5.5";
  pname = "jpegoptim";

  src = fetchFromGitHub {
    owner = "tjko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3p3kcUur1u09ROdKXG5H8eilu463Rzbn2yfYo5o6+KM=";
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
    mainProgram = "jpegoptim";
  };
}
