{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "hns";
  version = "1.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "primaprashant";
    repo = "hns";
    tag = finalAttrs.version;
    hash = "sha256-VO9EX8aIudijAyzTH9cXIa1magN+wkIE0lsP+DGl8hw=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    click
    faster-whisper
    numpy
    pyperclip
    requests
    rich
    sounddevice
  ];

  pythonImportsCheck = [
    "hns"
  ];

  meta = {
    description = "Speech-to-text CLI to transcribe voice from microphone directly to clipboard";
    homepage = "https://hns-cli.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      afh
      dwt
    ];
  };
})
