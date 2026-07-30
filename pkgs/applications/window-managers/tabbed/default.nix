{
  lib,
  stdenv,
  fetchgit,
  xorgproto,
  libx11,
  libxft,
  customConfig ? null,
  patches ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tabbed";
  version = "0.9";

  src = fetchgit {
    url = "https://git.suckless.org/tabbed";
    rev = finalAttrs.version;
    hash = "sha256-IpFbkyNNzMtESjpQNFOUdE6Tl+ezJN85T71Cm7bqljo=";
  };

  inherit patches;

  postPatch = lib.optionalString (customConfig != null) ''
    cp ${builtins.toFile "config.h" customConfig} ./config.h
  '';

  buildInputs = [
    xorgproto
    libx11
    libxft
  ];

  makeFlags = [ "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://tools.suckless.org/tabbed";
    description = "Simple generic tabbed fronted to xembed aware applications";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
