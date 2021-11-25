{ lib
, buildPythonApplication
, fetchPypi
, ffmpeg
, ffmpeg-progress-yield
}:

buildPythonApplication rec {
  pname = "ffmpeg-normalize";
  version = "1.22.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a20978538ae9a51bdbe5ef5aa0f87ede0f8efd2817ab240980de56eac36982e3";
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
