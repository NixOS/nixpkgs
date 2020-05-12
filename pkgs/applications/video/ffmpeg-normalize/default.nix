{ lib
, buildPythonApplication
, fetchPypi
, ffmpeg
, tqdm
}:

buildPythonApplication rec {
  pname = "ffmpeg-normalize";
  version = "1.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18dpck9grnr3wgbjvdh4mjlx0zfwcxpy4rnpmc39in0yk3w7li2x";
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
