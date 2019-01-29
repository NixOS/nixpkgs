{ stdenv, fetchurl, pkgconfig, writeText, libX11, ncurses
, libXft, conf ? null, patches ? [], extraLibs ? []}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "st-0.8.1";

  src = fetchurl {
    url = "https://dl.suckless.org/st/${name}.tar.gz";
    sha256 = "09k94v3n20gg32xy7y68p96x9dq5msl80gknf9gbvlyjp3i0zyy4";
  };

  inherit patches;

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  nativeBuildInputs = [ pkgconfig ncurses ];
  buildInputs = [ libX11 libXft ] ++ extraLibs;

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  meta = {
    homepage = https://st.suckless.org/;
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [andsild];
    platforms = platforms.linux;
  };
}
