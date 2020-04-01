{ lib
, buildPythonApplication
, fetchPypi
, ffmpeg
, tqdm
}:

buildPythonApplication rec {
  pname = "ffmpeg-normalize";
  version = "1.15.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01lx1ki1iglg1dz6x99ciqx5zqlbj7hvfb12ga9m68ypjm0fcphl";
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
