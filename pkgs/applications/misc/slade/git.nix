{ stdenv, fetchFromGitHub, cmake, pkgconfig, wxGTK30-gtk3, gtk3, sfml, fluidsynth, curl, freeimage, ftgl, glew, zip, lua, fmt, mpg123, wrapGAppsHook }:

let
  wxGTK = wxGTK30-gtk3.override { withGtk2 = false; withWebKit = true; };
in stdenv.mkDerivation {
  name = "slade-git-3.2.0.2020.08.21";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "b247aab888afe1127f963f5572d81a8985a55446";
    sha256 = "1qvfs9j5hnyi9i1qdyvyfijk1dg2j5j4i1l6i84anzd191c5hpzm";
  };

  cmakeFlags = [ "-DwxWidgets_CONFIG_EXECUTABLE=${wxGTK.out}/bin/wx-config" ];
  nativeBuildInputs = [ cmake pkgconfig zip wrapGAppsHook ];
  buildInputs = [ wxGTK gtk3 sfml fluidsynth curl freeimage ftgl glew lua fmt mpg123 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ ertes ];
  };
}
