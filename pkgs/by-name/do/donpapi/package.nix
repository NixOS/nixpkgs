{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "donpapi";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "login-securite";
    repo = "DonPAPI";
    tag = "V${version}";
    hash = "sha256-60aGnsr36X3mf91nH9ud0xyLBqKgzZ4ALucrLGpAuzQ=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "impacket"
    "pyasn1"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    cryptography
    impacket
    lnkparse3
    pyasn1
    pyjwt
    setuptools
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "donpapi" ];

  meta = with lib; {
    description = "Tool for dumping DPAPI credentials remotely";
    homepage = "https://github.com/login-securite/DonPAPI";
    changelog = "https://github.com/login-securite/DonPAPI/releases/tag/V${src.tag}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "donpapi";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
