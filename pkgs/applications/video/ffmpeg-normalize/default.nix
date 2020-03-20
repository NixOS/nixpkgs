{ lib
, buildPythonApplication
, fetchPypi
, ffmpeg
, tqdm
}:

buildPythonApplication rec {
  pname = "ffmpeg-normalize";
  version = "1.15.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0161939f864e973b11d50170c657baf3e1433147f46c74a74ed5025a822e9a2d";
  };

  propagatedBuildInputs = [ ffmpeg tqdm ];

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
