{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  openssl,
}:

python3Packages.buildPythonApplication rec {
  pname = "opendrop";
  version = "0.13.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "seemoo-lab";
    repo = "opendrop";
    tag = "v${version}";
    hash = "sha256-4FeVQO7Z6t9mjIgesdjKx4Mi+Ro5EVGJpEFjCvB2SlA=";
  };

  nativeBuildInputs = [
    # Tests fail if I put it on buildInputs
    openssl
  ];

  dependencies = with python3Packages; [
    fleep
    ifaddr
    libarchive-c
    pillow
    requests-toolbelt
    setuptools
    zeroconf
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath nativeBuildInputs}"
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  meta = {
    description = "Open Apple AirDrop implementation written in Python";
    homepage = "https://owlink.org/";
    changelog = "https://github.com/seemoo-lab/opendrop/releases/tag/${src.rev}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "opendrop";
    platforms = [ "x86_64-linux" ];
  };
}
