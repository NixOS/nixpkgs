{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "bnnumerizer";
  version = "0.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qd9v0Le1GqTsR3a2ZDzt6+5f0R4zXX1W1KIMCFFeXw0=";
  };

  pythonImportsCheck = [ "bnnumerizer" ];

  # https://github.com/mnansary/bnUnicodeNormalizer/issues/10
  doCheck = false;

  meta = with lib; {
    description = "Bangla Number text to String Converter";
    homepage = "https://github.com/banglakit/number-to-bengali-word";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
