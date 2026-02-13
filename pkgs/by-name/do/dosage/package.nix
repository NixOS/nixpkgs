{
  lib,
  python3Packages,
  fetchPypi,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dosage";
  version = "3.2";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-MHikoqbsQ2WkDi+S+1fhHuJy/cwzHu6PVy/JfALNJUI=";
  };

  pyproject = true;

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-xdist
    responses
  ];

  build-system = [ python3Packages.setuptools-scm ];

  dependencies = with python3Packages; [
    brotli
    imagesize
    lxml
    platformdirs
    requests
    rich
    zstandard
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Comic strip downloader and archiver";
    mainProgram = "dosage";
    homepage = "https://dosage.rocks/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toonn ];
  };
})
