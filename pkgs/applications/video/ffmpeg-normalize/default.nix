{ lib
, buildPythonApplication
, fetchPypi
, ffmpeg
, ffmpeg-progress-yield
}:

buildPythonApplication rec {
  pname = "ffmpeg-normalize";
  version = "1.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DSBh3m7gGm5fWH47YWALlyhi4x6A2RcVrpuDDpXolSI=";
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
