{
  lib,
  python3Packages,
  fetchFromGitHub,
  yt-dlp,
}:

python3Packages.buildPythonApplication rec {
  pname = "auto-editor";
  version = "28.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WyattBlue";
    repo = "auto-editor";
    tag = version;
    hash = "sha256-n+9qesm2LCTXJ+X/hDaFQ5EjN+xfnLdl6G8+Qna/cyM=";
  };

  postPatch = ''
    substituteInPlace auto_editor/__main__.py \
      --replace-fail '"yt-dlp"' '"${lib.getExe yt-dlp}"'
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    basswood-av
    numpy
  ];

  checkPhase = ''
    runHook preCheck

    $out/bin/auto-editor test all

    runHook postCheck
  '';

  pythonImportsCheck = [ "auto_editor" ];

  meta = {
    changelog = "https://github.com/WyattBlue/auto-editor/releases/tag/${src.tag}";
    description = "Command line application for automatically editing video and audio by analyzing a variety of methods, most notably audio loudness";
    homepage = "https://auto-editor.com/";
    license = lib.licenses.unlicense;
    mainProgram = "auto-editor";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
