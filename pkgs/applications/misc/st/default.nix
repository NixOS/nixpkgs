{ stdenv, fetchurl, pkgconfig, writeText, libX11, ncurses
, libXft, conf ? null, patches ? [], extraLibs ? []}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "st-0.8.3";

  src = fetchurl {
    url = "https://dl.suckless.org/st/${name}.tar.gz";
    sha256 = "0ll5wbw1szs70wdf8zy1y2ig5mfbqw2w4ls8d64r8z3y4gdf76lk";
  };

  inherit patches;

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  postPatch = optionalString (conf!=null) "cp ${configFile} config.def.h";

  nativeBuildInputs = [ pkgconfig ncurses ];
  buildInputs = [ libX11 libXft ] ++ extraLibs;

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  meta = {
    homepage = "https://st.suckless.org/";
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [andsild];
    platforms = platforms.linux;
  };
}
