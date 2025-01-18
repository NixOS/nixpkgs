{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  version = "4.24";
  pname = "hebcal";

  src = fetchFromGitHub {
    owner = "hebcal";
    repo = "hebcal";
    rev = "v${version}";
    sha256 = "sha256-iWp2S3s8z/y4dZ66Ogqu7Yf4gTUvSS1J5F7d0ifRbcY=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://hebcal.github.io";
    description = "Perpetual Jewish Calendar";
    longDescription = "Hebcal is a program which prints out the days in the Jewish calendar for a given Gregorian year. Hebcal is fairly flexible in terms of which events in the Jewish calendar it displays.";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.hhm ];
    platforms = platforms.all;
    mainProgram = "hebcal";
  };
}
