{
  knot-resolver_6,
  python3Packages,
  extraFeatures ? false,
}:
let
  knot-resolver = knot-resolver_6.override { inherit extraFeatures; };
in
python3Packages.buildPythonPackage {
  pname = "knot-resolver-manager_6";
  inherit (knot-resolver) version;
  inherit (knot-resolver.unwrapped) src;
  pyproject = true;

  patches = [
    # Rewrap the two supervisor's binaries, so that they obtain access to python modules
    # defined in the manager.  Those are then used as extensions of supervisord.
    # Manager needs this fixed bin/supervisord on its $PATH.
    ./rewrap-supervisor.patch
  ];

  # Propagate meson config from the C part to the python part.
  # But the install-time etc differs from a sensible run-time etc.
  postPatch = ''
    substitute '${knot-resolver.unwrapped.config_py}'/knot_resolver/constants.py ./python/knot_resolver/constants.py \
      --replace-fail '${knot-resolver.unwrapped.out}/sbin' '${knot-resolver}/bin'
  ''
  # On non-Linux let's simplify construction of the knot-resolver command line,
  # as it would break because of nixpkgs-specific wrapping of python packages.
  + ''
    substituteInPlace python/knot_resolver/controller/supervisord/config_file.py \
      --replace-fail 'args = [sys.executable] + sys.argv' 'args = sys.argv'
  '';

  build-system = with python3Packages; [
    poetry-core
    setuptools
  ];

  # Deps can be seen in ${src}/pyproject.toml
  propagatedBuildInputs = with python3Packages; [
    aiohttp
    jinja2
    pyyaml
    prometheus-client
    supervisor
    typing-extensions
  ];

  doCheck = python3Packages.stdenv.isLinux; # maybe in future
  nativeCheckInputs = with python3Packages; [
    augeas
    dnspython
    lief
    pytestCheckHook
    pytest-asyncio
    pyroute2
    pyparsing
    toml
  ];

  preCheck = ''
    mkdir -p /tmp
  '';

  disabledTestPaths = [
    # FileNotFoundError: [Errno 2] No such file or directory: '/tmp/pytest-kresd-portdir/11076'
    "tests/pytests/test_conn_mgmt.py"
    "tests/pytests/test_edns.py"
    "tests/pytests/test_prefix.py"
    "tests/pytests/test_tls.py"
  ];

  disabledTests = [
    # FileNotFoundError: [Errno 2] No such file or directory: '/tmp/pytest-kresd-portdir/11076'
    "test_proxy_random_close"
    "test_proxy_rehandshake_tls12"
  ];

  passthru = {
    inherit knot-resolver;
  };

  meta = knot-resolver.meta // {
    mainProgram = "knot-resolver";
  };
}
