{
  lib,
  python3Packages,
  fetchPypi,
  ffmpeg-headless,
}:

python3Packages.buildPythonApplication rec {
  pname = "scdl";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cbNXSMH4UpRyG7U5Csu3ITtS7vp3xM/yVdyYReLcHIU=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    docopt-ng
    mutagen
    soundcloud-v2
    yt-dlp
  ];

  # Ensure ffmpeg is available in $PATH:
  makeWrapperArgs =
    let
      packagesToBinPath = [ ffmpeg-headless ];
    in
    [
      ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"''
    ];

  # No tests in repository
  doCheck = false;

  pythonImportsCheck = [ "scdl" ];

  meta = {
    description = "Download Music from Soundcloud";
    homepage = "https://github.com/flyingrub/scdl";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "scdl";
  };
}
