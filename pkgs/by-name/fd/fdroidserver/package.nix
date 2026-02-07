{
  lib,
  fetchFromGitLab,
  python3Packages,
  fetchPypi,
  apksigner,
  gradlew-fdroid,
  installShellFiles,
  withLibvirt ? true,
}:

let
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      sqlalchemy = self.sqlalchemy_1_4;
    }
  );
in
pythonPackages.buildPythonApplication rec {
  pname = "fdroidserver";
  version = "2.4.3-unstable-2026-01-05";

  pyproject = true;

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
    rev = "0382fd5a896b3629868f0f78f9bbc6297c48d469";
    hash = "sha256-U9NGUfEDRneV4SFMTQMo3JZen8imG/LpphduZt1udBo=";
  };

  pythonRemoveDeps = [
    "puremagic" # Only used as a fallback when magic is not installed
  ];

  postPatch = ''
    substituteInPlace fdroidserver/common.py \
      --replace-fail "FDROID_PATH = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))" "FDROID_PATH = '$out/bin'"
  '';

  preConfigure = ''
    ${pythonPackages.python.pythonOnBuildForHost.interpreter} setup.py compile_catalog
  '';

  postInstall = ''
    installShellCompletion --cmd fdroid \
      --bash completion/bash-completion
  '';

  nativeBuildInputs = [ installShellFiles ];

  build-system = with pythonPackages; [
    setuptools
    babel
  ];

  dependencies =
    with pythonPackages;
    [
      androguard
      clint
      defusedxml
      gitpython
      magic
      oscrypto
      paramiko
      pillow
      platformdirs
      asn1crypto
      pyyaml
      python-vagrant
      qrcode
      requests
      (ruamel-yaml.overrideAttrs (old: {
        src = fetchPypi {
          pname = "ruamel.yaml";
          version = "0.17.21";
          hash = "sha256-i3zml6LyEnUqNcGsQURx3BbEJMlXO+SSa1b/P10jt68=";
        };
      }))
      sdkmanager
      yamllint
    ]
    ++ lib.optionals withLibvirt [
      libvirt
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      biplist
      pycountry
    ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      apksigner
      gradlew-fdroid
    ]}"
  ];

  pythonImportsCheck = [ "fdroidserver" ];

  meta = {
    homepage = "https://gitlab.com/fdroid/fdroidserver";
    changelog = "https://gitlab.com/fdroid/fdroidserver/-/blob/${version}/CHANGELOG.md";
    description = "Server and tools for F-Droid, the Free Software repository system for Android";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      linsui
      jugendhacker
    ];
    mainProgram = "fdroid";
  };
}
