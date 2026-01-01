{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
let
<<<<<<< HEAD
  version = "1.2.16";
=======
  version = "1.2.14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
python3Packages.buildPythonApplication {
  pname = "mktxp";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "akpw";
    repo = "mktxp";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-jxXpgHSwqtbaj2oyPyWif8rr4fZNNo+ACRTFZ7aWQPc=";
=======
    hash = "sha256-4+0aw/r71FcVrxASco3AkYzi7zbFeiEkJB7acGdb1FQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = with python3Packages; [
    pypaInstallHook
    setuptoolsBuildHook
  ];

  dependencies = with python3Packages; [
    prometheus-client
    routeros-api
    configobj
    humanize
    texttable
    speedtest-cli
    waitress
    packaging
    pyyaml
  ];

  meta = {
    homepage = "https://github.com/akpw/mktxp";
    changelog = "https://github.com/akpw/mktxp/releases/tag/v${version}";
    description = "Prometheus Exporter for Mikrotik RouterOS devices";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.BonusPlay ];
    mainProgram = "mktxp";
  };
}
