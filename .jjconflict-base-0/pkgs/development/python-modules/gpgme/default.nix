{
  autoreconfHook,
  buildPythonPackage,
  gpgme,
  lib,
  setuptools,
  swig,
}:

buildPythonPackage {
  pname = "gpgme";
  inherit (gpgme) version src;
  pyproject = true;

  patches = gpgme.patches or [ ];

  postPatch = ''
    substituteInPlace lang/python/setup.py.in \
      --replace-fail "gpgme_h = '''" "gpgme_h = '${lib.getDev gpgme}/include/gpgme.h'" \
      --replace-fail "@VERSION@" "${gpgme.version}"
  '';

  configureFlags = gpgme.configureFlags ++ [
    "--enable-languages=python"
  ];

  postConfigure = "
    cd lang/python
  ";

  preBuild = ''
    make copystamp
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    autoreconfHook
    swig
  ];

  buildInputs = [
    gpgme
  ];

  pythonImportsCheck = [ "gpg" ];

  meta = gpgme.meta // {
    description = "Python bindings to the GPGME API of the GnuPG cryptography library";
    homepage = "https://dev.gnupg.org/source/gpgme/browse/master/lang/python/";
  };
}
