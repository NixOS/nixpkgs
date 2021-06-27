{ lib
, stdenv
, fetchurl
, pkg-config
, writeText
, libX11
, ncurses
, fontconfig
, freetype
, libXft
, conf ? null
, patches ? [ ]
, extraLibs ? [ ]
}:

with lib;

stdenv.mkDerivation rec {
  pname = "st";
  version = "0.8.4";

  src = fetchurl {
    url = "https://dl.suckless.org/st/${pname}-${version}.tar.gz";
    sha256 = "19j66fhckihbg30ypngvqc9bcva47mp379ch5vinasjdxgn3qbfl";
  };

  inherit patches;

  configFile = optionalString (conf != null) (writeText "config.def.h" conf);

  postPatch = optionalString (conf != null) "cp ${configFile} config.def.h"
    + optionalString stdenv.isDarwin ''
    substituteInPlace config.mk --replace "-lrt" ""
  '';

  strictDeps = true;

  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
  ];

  nativeBuildInputs = [
    pkg-config
    ncurses
    fontconfig
    freetype
  ];
  buildInputs = [
    libX11
    libXft
  ] ++ extraLibs;

  installPhase = ''
    runHook preInstall
    TERMINFO=$out/share/terminfo make install PREFIX=$out
    runHook postInstall
  '';

  meta = {
    homepage = "https://st.suckless.org/";
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [ andsild ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
