{stdenv, fetchgit, xorgproto, libX11, libXft, customConfig ? null, patches ? [] }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "tabbed-20180310";

  src = fetchgit {
    url = https://git.suckless.org/tabbed;
    rev = "b5f9ec647aae2d9a1d3bd586eb7523a4e0a329a3";
    sha256 = "0frj2yjaf0mfjwgyfappksfir52mx2xxd3cdg5533m5d88vbmxss";
  };

  inherit patches;

  postPatch = stdenv.lib.optionalString (customConfig != null) ''
    cp ${builtins.toFile "config.h" customConfig} ./config.h
  '';

  buildInputs = [ xorgproto libX11 libXft ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    homepage = https://tools.suckless.org/tabbed;
    description = "Simple generic tabbed fronted to xembed aware applications";
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.linux;
  };
}
