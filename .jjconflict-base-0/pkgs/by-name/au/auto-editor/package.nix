{
  lib,
  python3Packages,
  fetchFromGitHub,
  replaceVars,
  yt-dlp,
}:

python3Packages.buildPythonApplication rec {
  pname = "auto-editor";
  version = "26.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WyattBlue";
    repo = "auto-editor";
    tag = version;
    hash = "sha256-BYpt/EelCChhphfuTcqI/VIVis6dnt0J4FcNhWeiiyY=";
  };

  patches = [
    (replaceVars ./set-exe-paths.patch {
      yt_dlp = lib.getExe yt-dlp;
    })
  ];

  postPatch = ''
    # pyav is a fork of av, but has since mostly been un-forked
    substituteInPlace pyproject.toml \
        --replace-fail '"pyav==14.*"' '"av"'
  '';

  build-system = with python3Packages; [
    setuptools
  ];

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
    changelog = "https://github.com/WyattBlue/auto-editor/releases/tag/${version}";
    description = "Command line application for automatically editing video and audio by analyzing a variety of methods, most notably audio loudness";
    homepage = "https://auto-editor.com/";
    license = lib.licenses.unlicense;
    mainProgram = "auto-editor";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
