{
  python3Packages,
  fetchPypi,
  lib,
  flac,
  lame,
  opusTools,
  vorbis-tools,
  ffmpeg,
}:

python3Packages.buildPythonApplication rec {
  pname = "flac2all";
  version = "5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "OBjlr7cbSx2WOIfZUNwHy5Hpb2Fmh3vmZdc70JiWsiI=";
  };

  # Not sure why this is needed, but setup.py expects this to be set
  postPatch = ''
    echo ${version} > ./flac2all_pkg/version
  '';

  propagatedBuildInputs = [
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
          opusTools
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

  meta = with lib; {
    description = "Multi process, clustered, FLAC to multi codec audio converter with tagging support";
    mainProgram = "flac2all";
    homepage = "https://github.com/ZivaVatra/flac2all";
    license = licenses.gpl3;
    # TODO: This has only been tested on Linux, but may work on Mac too.
    platforms = platforms.linux;
  };
}
