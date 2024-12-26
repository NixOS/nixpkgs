{
  lib,
  stdenv,
  libusb1,
  pkg-config,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "ltwheelconf";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "thk";
    repo = "ltwheelconf";
    rev = "df55451f059d593b0259431662612ab5c2bef859";
    sha256 = "1fsz7k73yln987gcx1jvb5irxfbp1x2c457a60a8yap27nkp5y2w";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  installPhase = ''
    mkdir -p $out/bin
    cp ltwheelconf $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/thk/LTWheelConf";
    description = "Logitech wheels configuration tool";
    license = licenses.gpl3;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.linux;
    mainProgram = "ltwheelconf";
  };
}
