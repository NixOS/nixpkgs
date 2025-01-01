{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  SDL,
  SDL_gfx,
  SDL_image,
  tremor,
  flac,
  mpg123,
  libmikmod,
  speex,
  ncurses,
  keymap ? "default",
  conf ? "unknown",
}:

stdenv.mkDerivation rec {
  pname = "gmu";
  version = "0.10.1";

  src = fetchurl {
    url = "https://wej.k.vu/files/${pname}-${version}.tar.gz";
    sha256 = "03x0mc0xw2if0bpf0a15yprcyx1xccki039zvl2099dagwk6xskv";
  };

  patches = [
    # pull pending upstream inclusion fix for ncurses-6.3:
    #  https://github.com/jhe2/gmu/pull/7
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/jhe2/gmu/commit/c8b3a10afee136feb333754ef6ec26383b11072f.patch";
      sha256 = "0xp2j3jp8pkmv6yvnzi378m2dylbfsaqrsrkw7hbxw6kglzj399r";
    })

    # pull upstream fix for -fno-common toolchains like
    # upstream gcc-10 of clang-13.
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/jhe2/gmu/commit/b705209f08ddfda141ad358ccd0c3d2d099be5e6.patch";
      sha256 = "1ci2b8kz3r58rzmivlfhqjmcgqwlkwlzzhnyxlk36vmk240a3gqq";
    })
  ];

  buildInputs = [
    SDL
    SDL_gfx
    SDL_image
    tremor
    flac
    mpg123
    libmikmod
    speex
    ncurses
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    cp ${keymap}.keymap $out/share/gmu/default.keymap
    cp gmuinput.${conf}.conf $out/share/gmu/gmuinput.conf
    mkdir -p $out/etc/gmu
    cp gmu.${conf}.conf $out/etc/gmu/gmu.conf
  '';

  meta = {
    homepage = "http://wejp.k.vu/projects/gmu";
    description = "Open source music player for portable gaming consoles and handhelds";
    license = lib.licenses.gpl2;
  };
}
