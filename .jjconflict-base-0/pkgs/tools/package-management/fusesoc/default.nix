{
  buildPythonPackage,
  fetchPypi,
  lib,
  iverilog,
  verilator,
  gnumake,
  edalize,
  fastjsonschema,
  pyparsing,
  pyyaml,
  simplesat,
  ipyxact,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "fusesoc";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M36bXBgY8hR33AVDlHoH8PZJG2Bi0KOEI07IMns7R4w=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    edalize
    fastjsonschema
    pyparsing
    pyyaml
    simplesat
    ipyxact
  ];

  pythonImportsCheck = [ "fusesoc" ];

  makeWrapperArgs = [
    "--suffix PATH : ${
      lib.makeBinPath [
        iverilog
        verilator
        gnumake
      ]
    }"
  ];

  meta = with lib; {
    homepage = "https://github.com/olofk/fusesoc";
    description = "Package manager and build tools for HDL code";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
    mainProgram = "fusesoc";
  };
}
