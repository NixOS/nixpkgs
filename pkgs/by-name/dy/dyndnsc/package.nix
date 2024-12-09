{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "dyndnsc";
  version = "0.6.1-unstable-2024-02-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "infothrill";
    repo = "python-dyndnsc";
    rev = "75f82ce64a91b9fd25cd362d295095be4dab72b5";
    hash = "sha256-2SWtYQ3TaFbuHxABBUeXSqgfCA/T8lCAB+9mAIyjySU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    daemonocle
    dnspython
    json-logging
    netifaces
    requests
    setuptools
    responses
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-console-scripts
    pytestCheckHook
  ];

  disabledTests = [
    # dnswanip connects to an external server to discover the
    # machine's IP address.
    "dnswanip"
    # AssertionError
    "test_null_dummy"
  ];
  # Allow tests that bind or connect to localhost on macOS.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Dynamic DNS update client with support for multiple protocols";
    longDescription = ''
      Dyndnsc is a command line client for sending updates to Dynamic
      DNS (DDNS, DynDNS) services. It supports multiple protocols and
      services, and it has native support for IPv6. The configuration
      file allows using foreign, but compatible services. Dyndnsc
      ships many different IP detection mechanisms, support for
      configuring multiple services in one place and it has a daemon
      mode for running unattended. It has a plugin system to provide
      external notification services.
    '';
    homepage = "https://github.com/infothrill/python-dyndnsc";
    changelog = "https://github.com/infothrill/python-dyndnsc/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "dyndnsc";
    platforms = platforms.unix;
  };
}
