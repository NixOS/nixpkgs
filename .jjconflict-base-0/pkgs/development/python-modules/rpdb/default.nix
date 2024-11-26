{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "rpdb";
  version = "0.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d1a1cee34378ab075879dc30fa6328d448a9f680a66c4e84cac7382ad92f15f";
  };

  meta = with lib; {
    description = "pdb wrapper with remote access via tcp socket";
    homepage = "https://github.com/tamentis/rpdb";
    license = licenses.bsd2;
  };
}
