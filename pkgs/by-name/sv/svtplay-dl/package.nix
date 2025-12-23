{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  python3Packages,
  perl,
  ffmpeg,
}:

let

  inherit (python3Packages)
    buildPythonApplication
    setuptools
    requests
    pysocks
    cryptography
    pyyaml
    pytestCheckHook
    mock
    requests-mock
    ;

  version = "4.163";

in

buildPythonApplication {
  pname = "svtplay-dl";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spaam";
    repo = "svtplay-dl";
    rev = version;
    hash = "sha256-2Qge6jmmymIBPWVwaY43h/njlqGzQWPD718gsaIAYx0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    pysocks
    cryptography
    pyyaml
  ];

  nativeBuildInputs = [
    # For `pod2man(1)`.
    perl
    installShellFiles
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    requests-mock
  ];

  pytestFlags = [
    "--doctest-modules"
  ];

  enabledTestPaths = [
    "lib"
  ];

  postBuild = ''
    make svtplay-dl.1
  '';

  postInstall = ''
    installManPage svtplay-dl.1
    makeWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ ffmpeg ]}")
  '';

  postInstallCheck = ''
    $out/bin/svtplay-dl --help > /dev/null
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/spaam/svtplay-dl";
    description = "Command-line tool to download videos from svtplay.se and other sites";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "svtplay-dl";
  };
}
