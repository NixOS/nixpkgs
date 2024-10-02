{ lib, stdenv, fetchgit, xorgproto, libX11, libXft, customConfig ? null, patches ? [ ] }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tabbed";
  version = "0.8";

  src = fetchgit {
    url = "https://git.suckless.org/tabbed";
    rev = finalAttrs.version;
    hash = "sha256-KpMWBnnoF4AGRKrG30NQsVt0CFfJXVdlXLLag0Dq0sU=";
  };

  inherit patches;

  postPatch = lib.optionalString (customConfig != null) ''
    cp ${builtins.toFile "config.h" customConfig} ./config.h
  '';

  buildInputs = [ xorgproto libX11 libXft ];

  makeFlags = [ "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://tools.suckless.org/tabbed";
    description = "Simple generic tabbed fronted to xembed aware applications";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
})
