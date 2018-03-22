{ stdenv, fetchurl, pkgconfig, writeText, makeWrapper, libX11, ncurses, libXext
, libXft, fontconfig, dmenu, conf ? null, patches ? [], extraLibs ? []}:

with stdenv.lib;

let patches' = if patches == null then [] else patches;
in stdenv.mkDerivation rec {
  name = "st-0.8.1";

  src = fetchurl {
    url = "http://dl.suckless.org/st/${name}.tar.gz";
    sha256 = "09k94v3n20gg32xy7y68p96x9dq5msl80gknf9gbvlyjp3i0zyy4";
  };

  patches = patches';

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ libX11 ncurses libXext libXft fontconfig ] ++ extraLibs;

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
    wrapProgram "$out/bin/st" --prefix PATH : "${dmenu}/bin"
  '';

  meta = {
    homepage = https://st.suckless.org/;
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [viric andsild];
    platforms = platforms.linux;
  };
}
