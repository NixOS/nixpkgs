{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "rofi-mpd";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "Rofi_MPD";
    rev = "v${version}";
    sha256 = "0pdra1idgas3yl9z9v7b002igwg2c1mv0yw2ffb8rsbx88x4gbai";
  };

  propagatedBuildInputs = with python3Packages; [ mutagen mpd2 ];

  # upstream doesn't contain a test suite
  doCheck = false;

  meta = with lib; {
    description = "A rofi menu for interacting with MPD written in Python";
    homepage = "https://github.com/JakeStanger/Rofi_MPD";
    license = licenses.mit;
    maintainers = with maintainers; [ jakestanger ];
    platforms = platforms.all;
  };
}
