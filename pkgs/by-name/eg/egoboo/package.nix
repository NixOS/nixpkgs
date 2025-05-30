{
  lib,
  stdenv,
  fetchurl,
  libGLU,
  libGL,
  SDL,
  SDL_mixer,
  SDL_image,
  SDL_ttf,
}:

stdenv.mkDerivation rec {
  # pf5234 (a developer?) at freenode #egoboo told me that I better use 2.7.3 until
  # they fix more, because it even has at least one bugs less than 2.7.4.
  # 2.8.0 does not start properly on linux
  # They just starting making that 2.8.0 work on linux.
  pname = "egoboo";
  version = "2.7.3";

  src = fetchurl {
    url = "mirror://sourceforge/egoboo/egoboo-${version}.tar.gz";
    sha256 = "18cjgp9kakrsa90jcb4cl8hhh9k57mi5d1sy5ijjpd3p7zl647hd";
  };

  buildPhase = ''
    cd source
    make -C enet all
    # The target 'all' has trouble
    make -C game -f Makefile.unix egoboo
  '';

  # The user will need to have all the files in '.' to run egoboo, with
  # writeable controls.txt and setup.txt
  installPhase = ''
    mkdir -p $out/share/egoboo-${version}
    cp -v game/egoboo $out/share/egoboo-${version}
    cd ..
    cp -v -Rd controls.txt setup.txt players modules basicdat $out/share/egoboo-${version}
  '';

  buildInputs = [
    libGLU
    libGL
    SDL
    SDL_mixer
    SDL_image
    SDL_ttf
  ];

  /*
    This big commented thing may be needed for versions 2.8.0 or beyond
    I keep it here for future updates.

    # Some files have to go to $HOME, but we put them in the 'shared'.
    patchPhase = ''
      sed -i -e 's,''${HOME}/.''${PROJ_NAME},''${PREFIX}/share/games/''${PROJ_NAME},g' Makefile
    '';

    preBuild = ''
      makeFlags=PREFIX=$out
    '';
  */

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: mad.o:(.bss+0x233800): multiple definition of `tile_dict'; camera.o:(.bss+0x140): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  NIX_LDFLAGS = "-lm";

  meta = {
    description = "3D dungeon crawling adventure";

    homepage = "https://egoboo.sourceforge.net/";
    license = lib.licenses.gpl2Plus;

    # I take it out of hydra as it does not work as well as I'd like
    # maintainers = [ ];
    # platforms = lib.platforms.all;
  };
}
