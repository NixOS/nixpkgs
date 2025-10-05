{
  lib,
  stdenv,
  fetchFromGitHub,
  libjpeg,
}:

stdenv.mkDerivation rec {
  version = "1.5.6";
  pname = "jpegoptim";

  src = fetchFromGitHub {
    owner = "tjko";
    repo = "jpegoptim";
    rev = "v${version}";
    sha256 = "sha256-Nw9mz5zefkRwqkTIyBQyDlANHEx4dztiIiTuXUnuCKM=";
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
