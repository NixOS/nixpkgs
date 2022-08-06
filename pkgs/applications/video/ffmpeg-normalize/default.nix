{ lib
, buildPythonApplication
, fetchPypi
, ffmpeg
, ffmpeg-progress-yield
}:

buildPythonApplication rec {
  pname = "ffmpeg-normalize";
  version = "1.24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sQ8Qorf74ypMmpRd9b/wrqg28TZ295t6qkKosxyaG1I=";
  };

  propagatedBuildInputs = [ ffmpeg ffmpeg-progress-yield ];

  checkPhase = ''
    $out/bin/ffmpeg-normalize --help > /dev/null
  '';

  meta = with lib; {
    description = "Normalize audio via ffmpeg";
    homepage = "https://github.com/slhck/ffmpeg-normalize";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ prusnak ];
  };
}
