{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  setuptools,

  # dependencies
  numpy,
  nunavut,

  # optional dependencies
  cobs,
  libpcap,
  pyserial,
  python-can,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycyphal";
  version = "1.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenCyphal";
    repo = pname;
    tag = version;
    hash = "sha256-XkH0wss8ueh/Wwz0lhvQShOp3a4X9lNdosT/sMe7p4Q=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "numpy" ];

  dependencies = [
    numpy
    nunavut
  ];

  optional-dependencies = {
    transport-can-pythoncan = [ python-can ] ++ python-can.optional-dependencies.serial;
    transport-serial = [
      cobs
      pyserial
    ];
    transport-udp = [ libpcap ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ] ++ builtins.foldl' (x: y: x ++ y) [ ] (builtins.attrValues optional-dependencies);

  preCheck = ''
    export HOME=$TMPDIR
    export PYTHONASYNCIODEBUG=1
    python -c ${lib.escapeShellArg ''
      import pycyphal
      pycyphal.dsdl.compile_all(
        [
          "demo/public_regulated_data_types/uavcan",
          "demo/custom_data_types/sirius_cyber_corp",
        ],
        output_directory=".dsdl_compiled",
      )
    ''}
    export PYTHONPATH="$(pwd)/.dsdl_compiled:$PYTHONPATH"
  '';

  # These require extra permissions and/or actual hardware connected
  disabledTestPaths = [
    "pycyphal/application/__init__.py"
    "pycyphal/application/_transport_factory.py"
    "pycyphal/application/register/backend/dynamic.py"
    "pycyphal/application/register/backend/static.py"
    "pycyphal/transport/udp"
    "tests/application"
    "tests/demo"
    "tests/dsdl"
    "tests/presentation"
    "tests/transport"
    # These are flaky -- test against string representations of values
    "pycyphal/application/register/_registry.py"
    "pycyphal/application/register/_value.py"
  ];

  pythonImportsCheck = [ "pycyphal" ];

  meta = with lib; {
    description = "Full-featured implementation of the Cyphal protocol stack in Python";
    longDescription = ''
      Cyphal is an open technology for real-time intravehicular distributed computing and communication based on modern networking standards (Ethernet, CAN FD, etc.).
    '';
    homepage = "https://opencyphal.org/";
    changelog = "https://github.com/OpenCyphal/pycyphal/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    teams = [ teams.ororatech ];
  };
}
