{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "mloader";
  version = "1.1.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0o4FvhuFudNSEL6fwBVqxldaNePbbidY9utDqXiLRNc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "protobuf~=3.6" "protobuf"
  '';

  propagatedBuildInputs = with python3Packages; [
    click
    protobuf
    requests
  ];

  # No tests in repository
  doCheck = false;

  pythonImportsCheck = [ "mloader" ];

  meta = with lib; {
    description = "Command-line tool to download manga from mangaplus";
    homepage = "https://github.com/hurlenko/mloader";
    license = licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "mloader";
  };
}
