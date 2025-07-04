{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "dnsvalidator";
  version = "0.1-unstable-2023-01-17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vortexau";
    repo = "dnsvalidator";
    # https://github.com/vortexau/dnsvalidator/issues/21
    rev = "146c9b0e24d806b25697fbb541bf9f19a3086d41";
    hash = "sha256-8pbBEtkiaGYp5ekkA1UUZ+5DX/iarxKdpQn5hM3cmvA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'" ""
  '';

  pythonRemoveDeps = [ "ipaddress" ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    colorclass
    dnspython
    netaddr
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "dnsvalidator" ];

  meta = {
    description = "Tool to maintain a list of IPv4 DNS servers";
    homepage = "https://github.com/vortexau/dnsvalidator";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dnsvalidator";
  };
}
