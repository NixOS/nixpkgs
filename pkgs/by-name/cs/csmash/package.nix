{ lib
, stdenv
, SDL
, SDL_image
, SDL_mixer
, fetchpatch
, fetchurl
, gtk2
, libintl
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csmash";
  version = "0.6.6";

  src = fetchurl {
    url = "mirror://sourceforge/cannonsmash/csmash-${finalAttrs.version}.tar.gz";
    hash = "sha256-G+CyfaxGuokblVv48SIVG66m7gWzwpYWoJQjJQz9nT0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    SDL
    SDL_image
    SDL_mixer
    gtk2
    libintl
  ];

  patches = [
    (fetchpatch {
      url = "https://ftp5.gwdg.de/pub/linux/gentoo/gentoo-portage/games-simulation/cannonsmash/files/cannonsmash-${finalAttrs.version}-gcc41.patch";
      hash = "sha256-3bG6LxcFf3LWIEN/38ckgZkAlGT64nail64Oy+Q7gfM=";
    })
    (fetchpatch {
      url = "https://ftp5.gwdg.de/pub/linux/gentoo/gentoo-portage/games-simulation/cannonsmash/files/cannonsmash-${finalAttrs.version}-sizeof-cast.patch";
      hash = "sha256-QZW05SLw+3Ly0wgAtfJKV6CnlHqK0k2roDjjA6ayxI4=";
    })
  ];

  # otherwise it doesn't compile
  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Cannon Smash - a 3D table tennis game (works on X11)";
    homepage = "https://cannonsmash.sourceforge.net";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ alexoundos ];
    platforms = platforms.linux;
  };
})
