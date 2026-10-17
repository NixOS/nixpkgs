{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ssh-mitm";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ssh-mitm";
    repo = "ssh-mitm";
    tag = finalAttrs.version;
    hash = "sha256-ABzAXnyG77oCW6gzw67OJ/Amw7EHWM82Tsk+D6fFtpU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.32.0" "hatchling"
  '';

  pythonRelaxDeps = [ "paramiko" ];

  build-system = with python3.pkgs; [
    hatchling
    hatch-requirements-txt
  ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies =
    with python3.pkgs;
    [
      aiohttp
      appimage
      argcomplete
      colored
      lxml
      markdown
      packaging
      paramiko
      protobuf
      psrpcore
      pyte
      python-json-logger
      pytz
      pyyaml
      requests
      rich
      setuptools
      sshpubkeys
      textual
      tkinter
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
    changelog = "https://github.com/ssh-mitm/ssh-mitm/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
