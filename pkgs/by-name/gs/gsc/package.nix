{
  lib,
  stdenv,
  fetchgit,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gsc";
  version = "1.3";

  src = fetchgit {
    url = "https://git.launchpad.net/gsc";
    rev = "dc6a7bee9ef8bd0732e06e350239ee5fce6c49e9";
    sha256 = "sha256-cub3XtdUWokNZmri5v7EkhwGrWfP0wxbRnJ337ldQnY=";
  };

  nativeBuildInputs = [ cmake ];

  preConfigure = "
    substituteInPlace gsc.c --replace '/usr/share/GSC' \\
      '${placeholder "out"}/share/GSC'
  ";

  cmakeFlags = [ "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://gsss.stsci.edu/Catalogs/Catalogs.htm";
    description = "Hubble Guide Stars Catalog";
    platforms = platforms.all;
    license = licenses.unfree;
    maintainers = with maintainers; [ bzizou ];
  };
})
