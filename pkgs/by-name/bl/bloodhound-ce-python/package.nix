{
  lib,
  fetchPypi,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "bloodhound-ce-py";
  version = "1.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "bloodhound_ce";
    hash = "sha256-9mPWGB4qGrjenVeUgBFmLipHiA2MrKm4U2mn767ROnA=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    dnspython
    impacket
    ldap3
    pycryptodome
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "bloodhound" ];

  meta = {
    description = "Python based ingestor for BloodHound (Community Edition), based on Impacket";
    mainProgram = "bloodhound-ce-python";
    homepage = "https://github.com/dirkjanm/BloodHound.py/tree/bloodhound-ce";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marv963 ];
  };
}
