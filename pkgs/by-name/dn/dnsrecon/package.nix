{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnsrecon";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darkoperator";
    repo = "dnsrecon";
    rev = "refs/tags/${version}";
    hash = "sha256-CW5HM8hATfhyQDbSAV+zSp8Gc/C5uy40yKMJAGawn0k=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    dnspython
    loguru
    lxml
    netaddr
    requests
    setuptools
  ];

  # Tests require access to /etc/resolv.conf
  doCheck = false;

  pythonImportsCheck = [ "dnsrecon" ];

  meta = with lib; {
    description = "DNS Enumeration script";
    homepage = "https://github.com/darkoperator/dnsrecon";
    changelog = "https://github.com/darkoperator/dnsrecon/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      c0bw3b
      fab
    ];
    mainProgram = "dnsrecon";
  };
}
