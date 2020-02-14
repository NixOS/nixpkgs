{ lib, python3Packages, ffmpeg }:

python3Packages.buildPythonApplication rec {
  pname = "r128gain";
  version = "0.9.3";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0dx2grryp0lj58bawx1zcq9a6b4ijz9r5qrg8h6nvm92kqlya26i";
  };

  propagatedBuildInputs = [ ffmpeg ]
    ++ (with python3Packages; [ crcmod mutagen tqdm ])
    ;

  doCheck = false; # downloads media files for testing

  meta = with lib; {
    description = "Fast audio loudness scanner & tagger (ReplayGain v2 / R128)";
    homepage = "https://github.com/desbma/r128gain";
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.AluisioASG ];
    platforms = platforms.all;
  };
}
