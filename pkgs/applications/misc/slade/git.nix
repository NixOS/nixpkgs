{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wxGTK
, sfml
, fluidsynth
, curl
, freeimage
, ftgl
, glew
, zip
, lua
, fmt
, mpg123
}:

stdenv.mkDerivation {
  pname = "slade";
  version = "unstable-2021-05-13";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "d2e249c89062a44c912a9b86951526edc8735ba0";
    sha256 = "08dsvx7m7c97jm8fxzivmi1fr47hj53y0lv57clqc35bh2gi62dg";
  };

  cmakeFlags = [
    "-DwxWidgets_CONFIG_EXECUTABLE=${wxGTK}/bin/wx-config"
    "-DWX_GTK3=OFF"
    "-DNO_WEBVIEW=1"
  ];
  nativeBuildInputs = [ cmake pkg-config zip ];
  buildInputs = [ wxGTK wxGTK.gtk sfml fluidsynth curl freeimage ftgl glew lua fmt mpg123 ];

  meta = with lib; {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ ertes ];
  };
}
