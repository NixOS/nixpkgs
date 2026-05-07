{
  lib,
  fetchFromGitHub,
  installShellFiles,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "sipvicious";
  version = "0.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnableSecurity";
    repo = "sipvicious";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OQq1PP0qoETu+0qs2vhkgVU5FVZA5wnWMKU+lKJrvv4=";
  };

  build-system = [
    installShellFiles
  ]
  ++ (with python3.pkgs; [
    setuptools
  ]);

  dependencies = with python3.pkgs; [
    scapy
  ];

  postInstall = ''
    installManPage man1/*.1
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "sipvicious"
  ];

  meta = {
    description = "Set of tools to audit SIP based VoIP systems";
    homepage = "https://github.com/EnableSecurity/sipvicious";
    changelog = "https://github.com/EnableSecurity/sipvicious/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
