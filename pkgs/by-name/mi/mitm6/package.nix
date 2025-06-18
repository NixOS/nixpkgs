{
  lib,
  fetchPypi,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mitm6";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g+eFcJdgP7CQ6ntN17guJa4LdkGIb91mr/NKRPIukP8=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    future
    netifaces
    scapy
    twisted
  ];

  # No tests exist for mitm6.
  doCheck = false;

  pythonImportsCheck = [ "mitm6" ];

  meta = {
    description = "DHCPv6 network spoofing application";
    homepage = "https://github.com/dirkjanm/mitm6";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mitm6";
  };
}
