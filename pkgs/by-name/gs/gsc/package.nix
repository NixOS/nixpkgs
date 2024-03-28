{ lib, stdenv, fetchgit, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "gsc";
  version = "1.3";

  src = fetchgit {
    url = "https://git.launchpad.net/gsc";
    sha256 = "sha256-U5lP8tpk8Vfsg2GMC80Az/oHdmqHApYZFX01clT/moo=";
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
