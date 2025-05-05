{
  bt-dualboot,
  chntpw,
  fetchPypi,
  lib,
  python3Packages,
  runCommand,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "bt-dualboot";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pjzGvLkotQllzyrnxqDIjGlpBOvUPkWpv0eooCUrgv8=";
  };

  format = "setuptools";

  strictDeps = true;

  dependencies = [ chntpw ];

  nativeBuildInputs = [ versionCheckHook ];

  passthru.tests.help = runCommand "help" { } ''
    ${bt-dualboot}/bin/bt-dualboot --help >/dev/null
    touch $out
  '';

  meta = {
    description = "Sync Bluetooth for dualboot Linux and Windows";
    homepage = "https://github.com/x2es/bt-dualboot";
    downloadPage = "https://pypi.org/project/${pname}";
    license = lib.licenses.mit;
    mainProgram = "bt-dualboot";
    maintainers = [ lib.maintainers.bmrips ];
    platforms = lib.platforms.linux;
  };
}
