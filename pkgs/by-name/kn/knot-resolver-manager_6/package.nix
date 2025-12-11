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

  doCheck = false; # FIXME
  checkInputs = with python3Packages; [
    python3Packages.augeas
    dnspython
    lief
    pytestCheckHook
    pytest-asyncio
    pyroute2
    pyparsing
    toml
  ];

  meta = knot-resolver_6.meta // {
    mainProgram = "knot-resolver";
  };
}
