{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "ltpycld2";
  version = "0.42";

  format = "setuptools";

  src = fetchPypi {
    pname = "LTpycld2";
    inherit version;
    sha256 = "948d0c1ab5518ab4efcbcc3cd73bb29f809f1dfb30f4d2fbd81b175a1ffeb516";
  };

  doCheck = false; # completely broken tests

  pythonImportsCheck = [ "pycld2" ];

  # Fix build with gcc14
  # https://github.com/aboSamoor/pycld2/pull/62
  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  meta = {
    description = "Python bindings around Google Chromium's embedded compact language detection library (CLD2)";
    homepage = "https://github.com/LibreTranslate/pycld2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ misuzu ];
  };
}
