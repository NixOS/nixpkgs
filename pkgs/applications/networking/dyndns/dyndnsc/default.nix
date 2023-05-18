{ stdenv, lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "dyndnsc";
  version = "0.6.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "13078d29eea2f9a4ca01f05676c3309ead5e341dab047e0d51c46f23d4b7fbb4";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "bottle==" "bottle>="
  '';

  nativeBuildInputs = with python3Packages; [ pytest-runner ];
  propagatedBuildInputs = with python3Packages; [
    daemonocle
    dnspython
    netifaces
    requests
    json-logging
    setuptools
  ];
  nativeCheckInputs = with python3Packages; [ bottle mock pytest-console-scripts pytestCheckHook ];

  disabledTests = [
    # dnswanip connects to an external server to discover the
    # machine's IP address.
    "dnswanip"
  ] ++ lib.optionals stdenv.isDarwin [
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
      DNS (DDNS, DynDNS) services.  It supports multiple protocols and
      services, and it has native support for IPv6.  The configuration
      file allows using foreign, but compatible services.  Dyndnsc
      ships many different IP detection mechanisms, support for
      configuring multiple services in one place and it has a daemon
      mode for running unattended.  It has a plugin system to provide
      external notification services.
    '';
    homepage = "https://github.com/infothrill/python-dyndnsc";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
    platforms = platforms.unix;
  };
}
