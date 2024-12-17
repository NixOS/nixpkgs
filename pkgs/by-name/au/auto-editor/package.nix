{
  lib,
  python3Packages,
  fetchFromGitHub,
  replaceVars,
  ffmpeg,
  yt-dlp,
}:

python3Packages.buildPythonApplication rec {
  pname = "auto-editor";
  version = "24w29a";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WyattBlue";
    repo = "auto-editor";
    rev = "refs/tags/${version}";
    hash = "sha256-2/6IqwMlaWobOlDr/h2WV2OqkxqVmUI65XsyBphTbpA=";
  };

  patches = [
    (replaceVars ./set-exe-paths.patch {
      ffmpeg = lib.getExe ffmpeg;
      yt_dlp = lib.getExe yt-dlp;
    })
  ];

  postPatch = ''
    # pyav is a fork of av, but has since mostly been un-forked
    substituteInPlace pyproject.toml \
        --replace-fail '"pyav==12.2.*"' '"av"'
  '';

  # our patch file also removes the dependency on ae-ffmpeg
  pythonRemoveDeps = [ "ae-ffmpeg" ];

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
