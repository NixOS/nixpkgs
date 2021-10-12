{ lib
, buildPythonApplication
, fetchPypi
, ffmpeg
, ffmpeg-progress-yield
}:

buildPythonApplication rec {
  pname = "ffmpeg-normalize";
  version = "1.22.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "317a9636587182280debc85d483f6d21987ceb6cd96ab36a2399836780eca822";
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
