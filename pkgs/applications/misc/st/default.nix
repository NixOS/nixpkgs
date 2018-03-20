{ stdenv, fetchurl, pkgconfig, writeText, libX11, ncurses, libXext, libXft
, fontconfig, conf ? null, patches ? [], extraLibs ? []}:

with stdenv.lib;

let patches' = if patches == null then [] else patches;
in stdenv.mkDerivation rec {
  name = "st-0.8";

  src = fetchurl {
    url = "http://dl.suckless.org/st/${name}.tar.gz";
    sha256 = "0xkmb7f1qq01ny1667c7bkf2zi3h4ryc6zpml22ccrkxs0h3jdbp";
  };

  patches = patches';

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 ncurses libXext libXft fontconfig ] ++ extraLibs;

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  meta = {
    homepage = https://st.suckless.org/;
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [viric andsild];
    platforms = platforms.linux;
  };
}
