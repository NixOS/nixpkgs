{
  lib,
  python3Packages,
  fetchFromGitHub,
  substituteAll,
  ffmpeg,
  yt-dlp,
}:

let
  inherit (python3Packages)
    buildPythonApplication
    setuptools
    numpy
    av
    ;
in
buildPythonApplication rec {
  pname = "auto-editor";
  version = "24w19a";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WyattBlue";
    repo = "auto-editor";
    rev = "refs/tags/${version}";
    hash = "sha256-dXiNU9wPubmlZJesxvQYGvv1ga68wt/rsP6L2sWtYkE=";
  };

  patches = [
    (substituteAll {
      src = ./set-exe-paths.patch;
      ffmpeg_path = lib.getExe ffmpeg;
      yt_dlp_path = lib.getExe yt-dlp;
    })
  ];

  postPatch = ''
    # pyav is a fork of av, but has since been un-forked
    substituteInPlace pyproject.toml \
        --replace-fail '"pyav==12.0.5"' '"av"' \
        --replace-fail '"ae-ffmpeg==1.2.*",' ""

    # thanks to the patches above, this is no longer needed
    rm -r ae-ffmpeg
  '';

  build-system = [ setuptools ];

  dependencies = [
    numpy
    av
  ];

  pythonImportsCheck = [ "auto_editor" ];

  postInstallCheck = ''
    $out/bin/auto-editor test all
  '';

  meta = {
    description = "A command line application for automatically editing video and audio by analyzing a variety of methods, most notably audio loudness";
    homepage = "https://auto-editor.com/";
    license = lib.licenses.unlicense;
    mainProgram = "auto-editor";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
