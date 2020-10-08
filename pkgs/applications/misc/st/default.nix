{ stdenv, fetchurl, pkgconfig, writeText, libX11, ncurses
, libXft, conf ? null, patches ? [], extraLibs ? []}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "st";
  version = "0.8.4";

  src = fetchurl {
    url = "https://dl.suckless.org/st/${pname}-${version}.tar.gz";
    sha256 = "19j66fhckihbg30ypngvqc9bcva47mp379ch5vinasjdxgn3qbfl";
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
