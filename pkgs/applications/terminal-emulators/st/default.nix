{ lib
, stdenv
, fetchurl
, pkg-config
, fontconfig
, freetype
, libX11
, libXft
, ncurses
, writeText
, conf ? null
, patches ? [ ]
, extraLibs ? [ ]
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "st";
  version = "0.9";

  src = fetchurl {
    url = "https://dl.suckless.org/st/st-${finalAttrs.version}.tar.gz";
    hash = "sha256-82NZeZc06ueFvss3QGPwvoM88i+ItPFpzSUbmTJOCOc=";
  };

  outputs = [ "out" "terminfo" ];

  inherit patches;

  configFile = lib.optionalString (conf != null)
    (writeText "config.def.h" conf);

  postPatch = lib.optionalString (conf != null) "cp ${finalAttrs.configFile} config.def.h"
    + lib.optionalString stdenv.isDarwin ''
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

  preInstall = ''
    export TERMINFO=$terminfo/share/terminfo
    mkdir -p $TERMINFO $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  installFlags = [ "PREFIX=$(out)" ];

  passthru.tests.test = nixosTests.terminal-emulators.st;

  meta = with lib; {
    homepage = "https://st.suckless.org/";
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [ andsild ];
    platforms = platforms.unix;
    mainProgram = "st";
  };
})
