{stdenv, fetchurl, libXaw, xproto, libXt, libX11, libSM, libICE, ncurses}:

stdenv.mkDerivation {
  name = "xterm-231";
  src = fetchurl {
    url = ftp://invisible-island.net/xterm/xterm-231.tgz;
    md5 = "b767d702e1464e16802b90c2187252c6"; /* was f7b04a66dc401dc22f5ddb7f345be229 */ /* was a062d0b398918015d07c31ecdcc5111a  */
  };
  buildInputs = [libXaw xproto libXt libX11 libSM libICE ncurses];
  configureFlags = ["--enable-wide-chars"];
}

