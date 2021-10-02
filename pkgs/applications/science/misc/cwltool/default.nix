{ lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "cwltool";
  version = "3.1.20210628163208";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "21b885f725420413d2f87eadc5e81c08a9c91beceda89b35d1a702ec4df47e52";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'prov == 1.5.1' 'prov'
  '';

  propagatedBuildInputs = with python3Packages; [
    argcomplete
    bagit
    coloredlogs
    mypy-extensions
    prov
    psutil
    pydot
    schema-salad
    shellescape
    typing-extensions
  ];

  doCheck = false; # hard to setup
  pythonImportsCheck = [ "cwltool" ];

  meta = with lib; {
    homepage = "https://www.commonwl.org";
    license = with licenses; [ asl20 ];
    description = "Common Workflow Language reference implementation";
    maintainers = with maintainers; [ veprbl ];
  };
}
