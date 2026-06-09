{
  lib,
  python3Packages,
  fetchPypi,
  ffmpeg-headless,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "scdl";
  version = "3.0.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-IwbH1YUeJuAf2rtKWfluyksRRkUab0UMuOWAP8L8rzE=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies =
    with python3Packages;
    [
      docopt-ng
      mutagen
      soundcloud-v2
      yt-dlp
    ]
    ++ yt-dlp.optional-dependencies.curl-cffi;

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
})
