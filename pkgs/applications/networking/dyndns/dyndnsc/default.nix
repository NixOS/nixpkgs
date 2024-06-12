{
  lib,
  stdenv,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "dyndnsc";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EweNKe6i+aTKAfBWdsMwnq1eNB2rBH4NUcRvI9S3+7Q=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  pythonRelaxDeps = [ "bottle" ];

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = with python3Packages; [ pythonRelaxDepsHook ];

  dependencies = with python3Packages; [
    daemonocle
    dnspython
    json-logging
    netifaces
    requests
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    bottle
    pytest-console-scripts
    pytestCheckHook
  ];

  disabledTests =
    [
      # dnswanip connects to an external server to discover the
      # machine's IP address.
      "dnswanip"
      # AssertionError
      "test_null_dummy"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # The tests that spawn a server using Bottle cannot be run on
      # macOS or Windows as the default multiprocessing start method
      # on those platforms is 'spawn', which requires the code to be
      # run to be picklable, which this code isn't.
      # Additionaly, other start methods are unsafe and prone to failure
      # on macOS; see https://bugs.python.org/issue33725.
      "BottleServer"
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
    maintainers = with maintainers; [ AluisioASG ];
    mainProgram = "dyndnsc";
    platforms = platforms.unix;
  };
}
