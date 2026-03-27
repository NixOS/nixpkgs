{
  python3Packages,
  fetchPypi,
  lib,
  flac,
  lame,
  opus-tools,
  vorbis-tools,
  ffmpeg,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "flac2all";
  version = "5.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-UGrkCQcpNzWH2hIRd1oTDryUeDumgHKuuxsbC87xaUI=";
  };

  # Not sure why this is needed, but setup.py expects this to be set
  postPatch = ''
    echo ${finalAttrs.version} > ./flac2all_pkg/version
  '';

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.pyzmq
  ];

  postInstall = ''
    wrapProgram $out/bin/flac2all \
      --set PATH ${
        lib.makeBinPath [
          # Hard requirements
          flac
          lame
          # Optional deps depending on encoding types
          opus-tools
          vorbis-tools
          ffmpeg
        ]
      }
  '';

  # Has no standard tests, so we verify a few imports instead.
  doCheck = false;
  pythonImportsCheck = [
    "flac2all_pkg.vorbis"
    "flac2all_pkg.mp3"
  ];

  meta = {
    description = "Multi process, clustered, FLAC to multi codec audio converter with tagging support";
    mainProgram = "flac2all";
    homepage = "https://github.com/ZivaVatra/flac2all";
    license = lib.licenses.gpl3;
    # TODO: This has only been tested on Linux, but may work on Mac too.
    platforms = lib.platforms.linux;
  };
})
