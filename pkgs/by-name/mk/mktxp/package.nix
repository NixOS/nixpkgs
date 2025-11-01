{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeWrapper,
  which,
}:
let
  version = "1.2.14";
in
python3Packages.buildPythonApplication {
  pname = "mktxp";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "akpw";
    repo = "mktxp";
    tag = "v${version}";
    hash = "sha256-4+0aw/r71FcVrxASco3AkYzi7zbFeiEkJB7acGdb1FQ=";
  };

  nativeBuildInputs = with python3Packages; [
    pypaInstallHook
    setuptoolsBuildHook
    makeWrapper
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

  postFixup = ''
    wrapProgram "$out/bin/mktxp" \
      --prefix PATH : ${lib.makeBinPath [ which ]}
  '';

  meta = {
    homepage = "https://github.com/akpw/mktxp";
    changelog = "https://github.com/akpw/mktxp/releases/tag/v${version}";
    description = "Prometheus Exporter for Mikrotik RouterOS devices";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [
      lib.maintainers.BonusPlay
      lib.maintainers.tsandrini
    ];
    mainProgram = "mktxp";
  };
}
