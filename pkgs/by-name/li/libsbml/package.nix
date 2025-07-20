{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  bzip2,
  libxml2,
  swig,
  python ? null,
  withPython ? false,
}:
stdenv.mkDerivation (attrs: {
  pname = "libsbml";
  version = "5.20.4";

  src = fetchFromGitHub {
    owner = "sbmlteam";
    repo = "libsbml";
    rev = "v${attrs.version}";
    hash = "sha256-qWTN033YU4iWzt+mXQaP5W/6IF5nebF4PwNVkyL8wTg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    swig
  ]
  ++ lib.optional withPython python.pkgs.pythonImportsCheckHook;

  buildInputs = [
    bzip2.dev
    libxml2
  ]
  ++ lib.optional withPython python;

  # libSBML doesn't always make use of pkg-config
  cmakeFlags = [
    "-DLIBXML_INCLUDE_DIR=${lib.getDev libxml2}/include/libxml2"
    "-DLIBXML_LIBRARY=${lib.getLib libxml2}/lib/libxml2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DPKG_CONFIG_EXECUTABLE=${lib.getBin pkg-config}/bin/pkg-config"
    "-DSWIG_EXECUTABLE=${lib.getBin swig}/bin/swig"
  ]
  ++ lib.optional withPython "-DWITH_PYTHON=ON";

  postInstall = lib.optional withPython ''
    mv $out/${python.sitePackages}/libsbml/libsbml.py $out/${python.sitePackages}/libsbml/__init__.py
  '';

  pythonImportsCheck = [ "libsbml" ];

  meta = with lib; {
    description = "Library for manipulating Systems Biology Markup Language (SBML)";
    homepage = "https://github.com/sbmlteam/libsbml";
    license = licenses.lgpl21Only;
    maintainers = [ maintainers.kupac ];
    platforms = platforms.all;
  };
})
