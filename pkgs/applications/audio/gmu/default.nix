{stdenv, fetchurl, SDL, SDL_gfx, SDL_image, tremor, flac, mpg123, libmikmod
, speex, ncurses
, keymap ? "default"
, conf ? "unknown"
}:

stdenv.mkDerivation rec {
  name = "gmu-0.10.1";

  src = fetchurl {
    url = "http://wejp.k.vu/files/${name}.tar.gz";
    sha256 = "03x0mc0xw2if0bpf0a15yprcyx1xccki039zvl2099dagwk6xskv";
  };

  buildInputs = [ SDL SDL_gfx SDL_image tremor flac mpg123 libmikmod speex ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    cp ${keymap}.keymap $out/share/gmu/default.keymap
    cp gmuinput.${conf}.conf $out/share/gmu/gmuinput.conf
    mkdir -p $out/etc/gmu
    cp gmu.${conf}.conf $out/etc/gmu/gmu.conf
  '';

  meta = {
    homepage = http://wejp.k.vu/projects/gmu;
    description = "Open source music player for portable gaming consoles and handhelds";
    license = stdenv.lib.licenses.gpl2;
  };
}
