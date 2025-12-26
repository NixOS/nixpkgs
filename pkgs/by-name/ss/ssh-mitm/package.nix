{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ssh-mitm";
  version = "5.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ssh-mitm";
    repo = "ssh-mitm";
    tag = version;
    hash = "sha256-FmxVhYkPRZwS+zFwuId9nRGN832LRkgCNgDYb8Pg01U=";
  };

  pythonRelaxDeps = [ "paramiko" ];

  build-system = with python3.pkgs; [
    hatchling
    hatch-requirements-txt
  ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies =
    with python3.pkgs;
    [
      appimage
      argcomplete
      colored
      packaging
      paramiko
      pytz
      pyyaml
      python-json-logger
      rich
      tkinter
      setuptools
      sshpubkeys
      wrapt
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ setuptools ];
  # fix for darwin users

  # Module has no tests
  doCheck = false;

  # Install man page
  postInstall = ''
    installManPage man1/*
  '';

  pythonImportsCheck = [ "sshmitm" ];

  meta = {
    description = "Tool for SSH security audits";
    homepage = "https://github.com/ssh-mitm/ssh-mitm";
    changelog = "https://github.com/ssh-mitm/ssh-mitm/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
