{
  lib,
  stdenv,
  fetchFromGitLab,
  python3Packages,
  fetchPypi,
  apksigner,
  gradlew-fdroid,
  installShellFiles,
  withLibvirt ? false,
}:

let
  pythonPackages = python3Packages.overrideScope (
    _final: prev: {
      # Match Debian Trixie's version because ruamel.yaml output changes can break
      # `fdroid rewritemeta`.
      ruamel-yaml = prev.ruamel-yaml.overridePythonAttrs {
        version = "0.18.10";
        src = fetchPypi {
          pname = "ruamel.yaml";
          version = "0.18.10";
          hash = "sha256-IMhqsprCFT+ApCjhJUqK32htM4PfBEkFFMo7eaNi21g=";
        };
      };
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "fdroidserver";
  version = "2.4.5-unstable-2026-06-11";

  pyproject = true;

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
    rev = "00932d0a715b43b3ecf8da44826abf2ba65dd8b4";
    hash = "sha256-ye+Zv8WreTXS+1dZZ6b56zPiRmcBrM2ea2nFcotrduQ=";
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
      asn1crypto
      defusedxml
      gitpython
      magic
      oscrypto
      paramiko
      pillow
      platformdirs
      progress
      python-vagrant
      pyyaml
      qrcode
      requests
      ruamel-yaml
      sdkmanager
      yamllint
    ]
    ++ lib.optional withLibvirt libvirt-python
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

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "fdroidserver" ];

  meta = {
    homepage = "https://gitlab.com/fdroid/fdroidserver";
    changelog = "https://gitlab.com/fdroid/fdroidserver/-/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Server and tools for F-Droid, the Free Software repository system for Android";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      linsui
      jugendhacker
    ];
    mainProgram = "fdroid";
  };
})
