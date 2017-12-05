{ stdenv, fetchurl, pkgconfig, writeText, libX11, ncurses, libXext, libXft
, fontconfig, conf ? null, patches ? [], extraLibs ? []}:

with stdenv.lib;

let patches' = if patches == null then [] else patches;
in stdenv.mkDerivation rec {
  name = "st-0.7";

  src = fetchurl {
    url = "http://dl.suckless.org/st/${name}.tar.gz";
    sha256 = "f7870d906ccc988926eef2cc98950a99cc78725b685e934c422c03c1234e6000";
  };

  patches = patches' ++ [ ./st-fix-deletekey.patch ];

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  buildInputs = [ pkgconfig libX11 ncurses libXext libXft fontconfig ] ++ extraLibs;

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  meta = {
    homepage = http://st.suckless.org/;
    license = licenses.mit;
    maintainers = with maintainers; [viric andsild];
    platforms = platforms.linux;
  };
}
