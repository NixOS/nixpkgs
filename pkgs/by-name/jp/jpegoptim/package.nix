{
  lib,
  stdenv,
  fetchFromGitHub,
  libjpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.5.6";
  pname = "jpegoptim";

  src = fetchFromGitHub {
    owner = "tjko";
    repo = "jpegoptim";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Nw9mz5zefkRwqkTIyBQyDlANHEx4dztiIiTuXUnuCKM=";
  };

  # There are no checks, it seems.
  doCheck = false;

  buildInputs = [ libjpeg ];

  meta = {
    description = "Optimize JPEG files";
    homepage = "https://www.kokkonen.net/tjko/projects.html";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "jpegoptim";
  };
})
