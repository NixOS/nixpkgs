{ lib, stdenv, fetchpatch, fetchFromGitHub, gtk3, rgbds, SDL2, wrapGAppsHook, glib }:

stdenv.mkDerivation rec {
  pname = "sameboy";
  version = "0.15.6";

  src = fetchFromGitHub {
    owner = "LIJI32";
    repo = "SameBoy";
    rev = "v${version}";
    sha256 = "sha256-WsZuOKq/Dfk2zgYFXSwZPUuPrJQJ3y3mJHL6s61mTig=";
  };

  enableParallelBuilding = true;
  # glib and wrapGAppsHook are needed to make the Open ROM menu work.
  nativeBuildInputs = [ rgbds glib wrapGAppsHook ];
  buildInputs = [ SDL2 ];

  patches = [
    (fetchpatch {
      url = "https://github.com/LIJI32/SameBoy/commit/c0966ceebaf1cf2518427ffa3c0189d8f96ab5aa.patch";
      hash = "sha256-2o/aWimtAKqay7SGq5Q9vLDcQKqV6Bn2xJtnjACrLUw=";
    })
  ];

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
