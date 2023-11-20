{ buildPythonPackage, lib, click, colorama, fetchPypi, setuptools-git }:

buildPythonPackage rec {
  pname = "snowmachine";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v385hhxy2a8vx5p0fhn0di8l4qfpb0a86j6nwsg0aw6ngb09qf1";
  };

  buildInputs = [ setuptools-git ];
  propagatedBuildInputs = [ click colorama ];

  doCheck = false;
  pythonImportsCheck = [ "snowmachine" ];

  meta = with lib; {
    description = "A python script that will make your terminal snow";
    homepage = "https://github.com/sontek/snowmachine";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ djanatyn ];
  };
}
