{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  python3,
}:

let
  py = python3.override {
    self = py;
    packageOverrides = self: super: {
      paramiko = super.paramiko.overridePythonAttrs (oldAttrs: rec {
        version = "3.4.1";
        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-ixUwKHCvf2ZS8uA4l1wdKXPwYEbLXX1lNVZos+y+zgw=";
        };
        dependencies = oldAttrs.dependencies ++ [ python3.pkgs.icecream ];
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "ssh-mitm";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ssh-mitm";
    repo = "ssh-mitm";
    rev = "refs/tags/${version}";
    hash = "sha256-jRheKLAXbbMyxdtDSJ4QSN4PoUM2YoK7nmU5xqPq7DY=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
  ];

  dependencies = [
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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ setuptools ];
  # fix for darwin users

  nativeBuildInputs = [ installShellFiles ];

  # Module has no tests
  doCheck = false;
  # Install man page
  postInstall = ''
    installManPage man1/*
  '';

  pythonImportsCheck = [ "sshmitm" ];

  meta = with lib; {
    description = "Tool for SSH security audits";
    homepage = "https://github.com/ssh-mitm/ssh-mitm";
    changelog = "https://github.com/ssh-mitm/ssh-mitm/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
