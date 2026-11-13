{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  bzip2,
  libxml2,
  nix-update-script,
  swig,
  zlib,
  python ? null,
  withPython ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libsbml";
  version = "5.21.2";

  src = fetchFromGitHub {
    owner = "sbmlteam";
    repo = "libsbml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zQzVTC2bWV7cgimu6sRq7IA4Kix8ubxVfVQJUo8Ft2Q=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    swig
  ]
  ++ lib.optional withPython python.pkgs.pythonImportsCheckHook;

  buildInputs = [
    bzip2
    libxml2
    zlib
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

  postInstall = lib.optionalString withPython ''
    mv $out/${python.sitePackages}/libsbml/libsbml.py $out/${python.sitePackages}/libsbml/__init__.py
  '';

  pythonImportsCheck = [ "libsbml" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Library for manipulating Systems Biology Markup Language (SBML)";
    homepage = "https://github.com/sbmlteam/libsbml";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.kupac ];
    platforms = lib.platforms.all;
  };
})
