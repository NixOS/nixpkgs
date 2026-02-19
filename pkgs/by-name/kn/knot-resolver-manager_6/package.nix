{
  lib,
  knot-resolver_6,
  python3Packages,
  extraFeatures ? false, # catch-all if defaults aren't enough
}:
let
  kresd = knot-resolver_6.finalPackage; # TODO: does the finalPackage help us?
in
assert lib.versionAtLeast kresd.version "6.0.0";
python3Packages.buildPythonPackage {
  pname = "knot-resolver-manager_6";
  inherit (kresd) version src;
  pyproject = true;

  patches = [
    # Rewrap the two supervisor's binaries, so that they obtain access to python modules
    # defined in the manager.  Those are then used as extensions of supervisord.
    # Manager needs this fixed bin/supervisord on its $PATH.
    ./rewrap-supervisor.patch
  ];

  # Propagate meson config from the C part to the python part.
  postPatch = ''
    cp '${kresd.config_py}'/knot_resolver/constants.py ./python/knot_resolver/
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

  # set up (additional) Lua dependencies
  buildInputs =
    with kresd.lua;
    lib.optionals extraFeatures [
      # For http module, prefill module, trust anchor bootstrap.
      # It brings lots of deps; some are useful elsewhere (e.g. cqueues).
      http
      # used by policy.slice_randomize_psl()
      psl
    ];
  makeWrapperArgs = [
    "--set"
    "LUA_PATH"
    ''"$LUA_PATH"''
    "--set"
    "LUA_CPATH"
    ''"$LUA_CPATH"''
  ];
  # basic test that the wrapping works
  postCheck = lib.optionalString extraFeatures ''
    makeWrapper '${kresd}/bin/kresd' ./kresd \
      --set LUA_PATH  "$LUA_PATH" \
      --set LUA_CPATH "$LUA_CPATH"
    echo "Checking that 'http' module loads, i.e. lua search paths work:"
    echo "modules.load('http')" > test-http.lua
    echo -e 'quit()' | env -i ./kresd -a 127.0.0.1#53535 -c test-http.lua
  '';

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
    inherit kresd;
  };

  meta = kresd.meta // {
    mainProgram = "knot-resolver";
    inherit (kresd.meta) description; # explicit to make e.g. `nix edit` point here
  };
}
