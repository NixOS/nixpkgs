{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "dnsrecon";
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darkoperator";
    repo = "dnsrecon";
    tag = finalAttrs.version;
    hash = "sha256-MkeHQZXWCqZ9/Z8WEVZIkDeLB/bnSxi8NBpgrcxAo+s=";
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
    changelog = "https://github.com/darkoperator/dnsrecon/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      c0bw3b
      fab
    ];
    mainProgram = "dnsrecon";
  };
})
