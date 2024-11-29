{ lib, stdenv
, fetchurl
, fetchpatch
, pkg-config
, desktop-file-utils
, SDL
, gtk3
, gsettings-desktop-schemas
, wrapGAppsHook3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfxr";
  version = "1.2.1";

  src = fetchurl {
    url = "http://www.drpetter.se/files/sfxr-sdl-${finalAttrs.version}.tar.gz";
    sha256 = "0dfqgid6wzzyyhc0ha94prxax59wx79hqr25r6if6by9cj4vx4ya";
  };

  patches = [
    # Fix segfault
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/sfxr/raw/223e58e68857c2018ced635e8209bb44f3616bf8/f/sfxr-sdl-gcc8x.patch";
      hash = "sha256-etn4AutkNrhEDH9Ep8MhH9JSJEd7V/JXwjQua5uhAmg=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile --replace "usr/" ""
    substituteInPlace sdlkit.h --replace \
      "/usr/share/sfxr/sfxr.bmp" \
      "$out/share/sfxr/sfxr.bmp"
    substituteInPlace main.cpp \
      --replace \
      "/usr/share/sfxr/font.tga" \
      "$out/share/sfxr/font.tga" \
      --replace \
      "/usr/share/sfxr/ld48.tga" \
      "$out/share/sfxr/ld48.tga"
  '';

  nativeBuildInputs = [
    pkg-config
    desktop-file-utils
  ];

  buildInputs = [
    SDL
    gtk3
    gsettings-desktop-schemas
    wrapGAppsHook3
  ];

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "http://www.drpetter.se/project_sfxr.html";
    description = "Videogame sound effect generator";
    mainProgram = "sfxr";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.unix;
  };
})
