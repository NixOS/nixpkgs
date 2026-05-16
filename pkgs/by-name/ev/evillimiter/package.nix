{
  lib,
  fetchFromGitHub,
  iproute2,
  iptables,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "evillimiter";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bitbrute";
    repo = "evillimiter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h6BReZcDW2UYaYYVQVgV0T91/+CsGuZf+J+boUhjCtA=";
  };

  build-system = with python3Packages; [ setuptools-scm ];

  dependencies = with python3Packages; [
    colorama
    iproute2
    iptables
    netaddr
    netifaces
    setuptools
    scapy
    terminaltables
    tqdm
  ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Tool that monitors, analyzes and limits the bandwidth";
    longDescription = ''
      A tool to monitor, analyze and limit the bandwidth (upload/download) of
      devices on your local network without physical or administrative access.
      evillimiter employs ARP spoofing and traffic shaping to throttle the
      bandwidth of hosts on the network.
    '';
    homepage = "https://github.com/bitbrute/evillimiter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "evillimiter";
  };
})
