{
  lib,
  python3Packages,
  fetchPypi,
  ffmpeg-headless,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "scdl";
  version = "3.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-r7cvsoKTWE0W/pbjmbaGqra9+qb1MDxf2B5C/rdrCdU=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    curl-cffi
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
})
