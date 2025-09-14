{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libpng,
  libsndfile,
}:

stdenv.mkDerivation rec {
  pname = "aptdec";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "Xerbo";
    repo = "aptdec";
    tag = "v${version}";
    hash = "sha256-5Pr2PlCPSEIWnThJXKcQEudmxhLJC2sVa9BfAOEKHB4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libpng
    libsndfile
  ];

  meta = {
    description = "NOAA APT satellite imagery decoding library";
    mainProgram = "aptdec";
    homepage = "https://github.com/Xerbo/aptdec";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ alexwinter ];
    platforms = lib.platforms.unix;
  };
}
