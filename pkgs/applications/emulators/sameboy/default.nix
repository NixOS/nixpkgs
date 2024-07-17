{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  rgbds,
  SDL2,
  wrapGAppsHook3,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "sameboy";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "LIJI32";
    repo = "SameBoy";
    rev = "v${version}";
    sha256 = "sha256-sQWmuF1dQgvW9WyOxgxaupTUcde3KzzYiGv+v1N5ssk=";
  };

  enableParallelBuilding = true;
  # glib and wrapGAppsHook3 are needed to make the Open ROM menu work.
  nativeBuildInputs = [
    rgbds
    glib
    wrapGAppsHook3
  ];
  buildInputs = [ SDL2 ];

  makeFlags = [
    "CONF=release"
    "FREEDESKTOP=true"
    "PREFIX=$(out)"
  ];

  postPatch = ''
    substituteInPlace OpenDialog/gtk.c \
      --replace '"libgtk-3.so"' '"${gtk3}/lib/libgtk-3.so"'
  '';

  meta = with lib; {
    homepage = "https://sameboy.github.io";
    description = "Game Boy, Game Boy Color, and Super Game Boy emulator";
    mainProgram = "sameboy";

    longDescription = ''
      SameBoy is a user friendly Game Boy, Game Boy Color and Super
      Game Boy emulator for macOS, Windows and Unix-like platforms.
      SameBoy is extremely accurate and includes a wide range of
      powerful debugging features, making it ideal for both casual
      players and developers. In addition to accuracy and developer
      capabilities, SameBoy has all the features one would expect from
      an emulator – from save states to scaling filters.
    '';

    license = licenses.mit;
    maintainers = with maintainers; [ NieDzejkob ];
    platforms = platforms.linux;
  };
}
