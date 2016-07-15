{stdenv, fetchgit, xproto, libX11, libXft, customConfig ? null, patches ? [] }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "tabbed-20160425";

  src = fetchgit {
    url = http://git.suckless.org/tabbed;
    rev = "bc236142fa72d2f9d6b5c790d3f3a9a9168a7164";
    sha256 = "1fiv57g3jnlhnb6zrzl3n6lnpn2s9s0sd7bcv7r1nb3grwy7icri";
  };

  inherit patches;

  postPatch = stdenv.lib.optionalString (customConfig != null) ''
    cp ${builtins.toFile "config.h" customConfig} ./config.h
  '';

  buildInputs = [ xproto libX11 libXft ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    homepage = http://tools.suckless.org/tabbed;
    description = "Simple generic tabbed fronted to xembed aware applications";
    license = licenses.mit;
    maintainers = with maintainers; [ viric vrthra ];
    platforms = platforms.linux;
  };
}
