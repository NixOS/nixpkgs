{ stdenv, fetchgit, lib, git, wxGTK31, cmake, mesa, mesa_glu, freeimage, freetype, pandoc, libX11 }:

stdenv.mkDerivation rec {
  pname = "TrenchBroom";
  version = "2019.6";

  src = fetchgit {
    url = "https://github.com/kduske/TrenchBroom.git";
    deepClone = true;
    rev = "v${version}";
    sha256 = "1yx09jcz7psg4l9m89amhda30lrclzk74rfp8avbhkz9bypkqn95";
  };

  buildInputs = [ mesa mesa_glu freeimage freetype pandoc wxGTK31 libX11 ];
  nativeBuildInputs = [ cmake git ];
  cmakeFlags = [ "-DwxWidgets_PREFIX=${wxGTK31}" ];
  hardeningDisable = [ "format" ];

  postInstall = "mkdir $out/share/applications; ln -s ../TrenchBroom/trenchbroom.desktop $out/share/applications";

  meta = with stdenv.lib; {
    description = "TrenchBroom is a modern cross-platform level editor for Quake-engine based games";
    homepage = http://kristianduske.com/trenchbroom;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ranguli ];
    platforms = platforms.all;
  };
}
