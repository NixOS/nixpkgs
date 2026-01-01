{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnsrecon";
<<<<<<< HEAD
  version = "1.5.2";
=======
  version = "1.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darkoperator";
    repo = "dnsrecon";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-FFe421hB1V8EQd3Uyl/3PvWwgn3YcRtz6k+umpiwfW4=";
=======
    hash = "sha256-RX7A/vF19wTcvm+kP4ynarzGY+pUIj84zQJIM3tO/2M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    dnspython
    loguru
    httpx
    fastapi
    uvicorn
    slowapi
    stamina
    ujson
    lxml
    netaddr
    requests
    setuptools
  ];

  # Tests require access to /etc/resolv.conf
  doCheck = false;

  pythonImportsCheck = [ "dnsrecon" ];

  meta = {
    description = "DNS Enumeration script";
    homepage = "https://github.com/darkoperator/dnsrecon";
    changelog = "https://github.com/darkoperator/dnsrecon/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      c0bw3b
      fab
    ];
    mainProgram = "dnsrecon";
  };
}
