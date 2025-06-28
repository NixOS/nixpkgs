{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libzip,
  boost,
  wt,
  libconfig,
  pkg-config,
  libarchive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fileshelter";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "epoupon";
    repo = "fileshelter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-21ANNJB7rbGAdlS7ELyGAEIjvK8biFlH27yVHrLKpwY=";
  };

  postPatch = ''
    sed -i '1i #include <algorithm>' src/fileshelter/ui/ShareCreateFormView.cpp
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libzip
    boost
    wt
    libconfig
    libarchive
  ];

  NIX_LDFLAGS = "-lpthread";

  postInstall = ''
    ln -s ${wt}/share/Wt/resources $out/share/fileshelter/docroot/resources
  '';

  meta = {
    homepage = "https://github.com/epoupon/fileshelter";
    description = "FileShelter is a 'one-click' file sharing web application";
    mainProgram = "fileshelter";
    maintainers = [ ];
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
})
