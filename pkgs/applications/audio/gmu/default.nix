{stdenv, fetchurl, SDL, SDL_gfx, SDL_image, tremor, flac, mpg123, libmikmod
, speex
, keymap ? "newdefault"
, conf ? "unknown"
}:

stdenv.mkDerivation rec {
  name = "gmu-0.7.2";
  
  src = fetchurl {
    url = http://wejp.k.vu/files/gmu-0.7.2.tar.gz;
    sha256 = "0gvhwhhlj64lc425wqch4g6v59ldd5i3rxll3zdcrdgk2vkh8nys";
  };

  buildInputs = [ SDL SDL_gfx SDL_image tremor flac mpg123 libmikmod speex ];

  NIX_LDFLAGS = "-lgcc_s";

  preBuild = ''
    makeFlags="$makeFlags PREFIX=$out"
  '';

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
