{
  lib,
  python3Packages,
  fetchFromGitHub,
  yt-dlp,
}:

python3Packages.buildPythonApplication rec {
  pname = "auto-editor";
  version = "28.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WyattBlue";
    repo = "auto-editor";
    tag = version;
    hash = "sha256-uSFihHYGfz3/b4aaK91qYFu9zx2gvpdKO0530NwV0E4=";
  };

  postPatch = ''
    substituteInPlace auto_editor/__main__.py \
      --replace-fail '"yt-dlp"' '"${lib.getExe yt-dlp}"'
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    av
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
