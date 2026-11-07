{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sqlcipher,
  openssl,
}:
let
  pname = "sqlcipher3";
  version = "0.6.4";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sCo+38VUyRl9Y6tMOKMPdoLuxlsQ5b4skoWg1v+3opo=";
  };

  postPatch = ''
    # Remove conan from build dependencies; it is used upstream to fetch
    # OpenSSL at build time, but we provide it via buildInputs instead.
    # setup.py already handles the missing conan case gracefully.
    substituteInPlace pyproject.toml \
      --replace-fail '"conan>=2.0",' ""
  '';

  build-system = [
    setuptools
  ];

  buildInputs = [
    sqlcipher
    openssl
  ];

  pythonImportsCheck = [
    "sqlcipher3"
  ];

  meta = {
    mainProgram = "sqlcipher3";
    homepage = "https://github.com/coleifer/sqlcipher3";
    description = "Python 3 bindings for SQLCipher";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ phaer ];
  };
}
