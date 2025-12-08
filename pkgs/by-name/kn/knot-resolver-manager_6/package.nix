{
  knot-resolver_6,
  writeText,
  python3Packages,
}:

python3Packages.buildPythonPackage {
  pname = "knot-resolver-manager_6";
  inherit (knot-resolver_6) version src;
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
    substitute '${knot-resolver_6.config_py}'/knot_resolver/constants.py ./python/knot_resolver/constants.py \
      --replace-fail '${knot-resolver_6.out}/etc' '/etc'
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

  meta = knot-resolver_6.meta // {
    mainProgram = "knot-resolver";
  };
}
