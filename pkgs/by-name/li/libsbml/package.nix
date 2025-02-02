{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  bzip2,
  libxml2,
  swig,
}:
stdenv.mkDerivation (attrs: {
  pname = "libsbml";
  version = "5.20.2";

  src = fetchFromGitHub {
    owner = "sbmlteam";
    repo = "libsbml";
    rev = "v${attrs.version}";
    hash = "sha256-8JT2r0zuf61VewtZaOAccaOUmDlQPnllA0fXE9rT5X8=";
  };

  patches = [
    # This should be in next release, remember to remove fetchpatch
    (fetchpatch {
      name = "fix-xmlerror-conversion.patch";
      url = "https://github.com/sbmlteam/libsbml/pull/358.patch";
      hash = "sha256-uirG6XJ+w0hqBUEAGDnzhHoVtJVRdN1eqBYeneKMBao=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    swig
  ];

  buildInputs = [
    bzip2.dev
    libxml2
  ];

  # libSBML doesn't always make use of pkg-config
  cmakeFlags = [
    "-DLIBXML_INCLUDE_DIR=${lib.getDev libxml2}/include/libxml2"
    "-DLIBXML_LIBRARY=${lib.getLib libxml2}/lib/libxml2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DPKG_CONFIG_EXECUTABLE=${lib.getBin pkg-config}/bin/pkg-config"
    "-DSWIG_EXECUTABLE=${lib.getBin swig}/bin/swig"
  ];

  meta = with lib; {
    description = "Library for manipulating Systems Biology Markup Language (SBML)";
    homepage = "https://github.com/sbmlteam/libsbml";
    license = licenses.lgpl21Only;
    maintainers = [maintainers.kupac];
    platforms = platforms.all;
  };
})
