{
  stdenv,
  lib,
  git,
  multipath-tools,
  openssl,
  ps,
  fetchFromGitLab,
  sudo,
  python3Packages,
  gitUpdater,
  util-linux,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "pmbootstrap";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "postmarketOS";
    repo = pname;
    tag = version;
    hash = "sha256-iJ3XK1aA3d0V5ATj2h6arHlTRKocmJ1AaySiq9bSJrs=";
    domain = "gitlab.postmarketos.org";
  };

  pmb_test = "${src}/test";

  # Tests depend on sudo
  doCheck = stdenv.hostPlatform.isLinux;

  build-system = [
    python3Packages.setuptools
  ];

  nativeCheckInputs = [
    git
    multipath-tools
    openssl
    ps
    python3Packages.pytestCheckHook
    sudo
    util-linux
    versionCheckHook
  ];

  # Add test dependency in PATH
  preCheck = ''
    export PYTHONPATH=$PYTHONPATH:${pmb_test}
  '';

  # skip impure tests
  disabledTests = [
    "test_pkgrepo_pmaports"
  ];

  versionCheckProgramArg = "--version";

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        git
        openssl
        multipath-tools
        util-linux
      ]
    }"
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Sophisticated chroot/build/flash tool to develop and install postmarketOS";
    homepage = "https://gitlab.com/postmarketOS/pmbootstrap";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      onny
      lucasew
    ];
    mainProgram = "pmbootstrap";
  };
}
