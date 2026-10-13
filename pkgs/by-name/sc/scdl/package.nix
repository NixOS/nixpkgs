{
  lib,
  python3Packages,
  fetchPypi,
  ffmpeg-headless,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "scdl";
  version = "3.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-dThICN/QF79LemNj621gX9EW4SXOs/hqPHLh0NGLxi8=";
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
