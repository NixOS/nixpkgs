{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, wxGTK, gtk2, sfml, fluidsynth
, curl, freeimage, ftgl, glew, zip, lua, mpg123 }:

stdenv.mkDerivation rec {
  pname = "slade";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = version;
    sha256 = "sha256-KFRX3sfI//Op/h/EfEuAZOY22RO5qNXmvhSksC0aS4U=";
  };

  nativeBuildInputs = [ cmake pkg-config zip ];
  buildInputs =
    [ wxGTK gtk2 sfml fluidsynth curl freeimage ftgl glew lua mpg123 ];

  cmakeFlags = [
    "-DwxWidgets_CONFIG_EXECUTABLE=${wxGTK}/bin/wx-config"
    "-DWX_GTK3=OFF"
    "-DNO_WEBVIEW=1"
  ];

  meta = with lib; {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
