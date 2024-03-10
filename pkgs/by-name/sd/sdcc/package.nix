{ lib
, stdenv
, fetchurl
, autoconf
, bison
, boost
, flex
, gputils
, texinfo
, zlib
, withGputils ? false
, excludePorts ? []
}:

assert lib.subtractLists [
  "ds390" "ds400" "gbz80" "hc08" "mcs51" "pic14" "pic16" "r2k" "r3ka" "s08"
  "stm8" "tlcs90" "z80" "z180"
] excludePorts == [];
stdenv.mkDerivation (finalAttrs: {
  pname = "sdcc";
  version = "4.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/sdcc/sdcc-src-${finalAttrs.version}.tar.bz2";
    hash = "sha256-rowSFl6xdoDf9EsyjYh5mWMGtyQe+jqDsuOy0veQanU=";
  };

  outputs = [ "out" "doc" "man" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoconf
    bison
    flex
  ];

  buildInputs = [
    boost
    texinfo
    zlib
  ] ++ lib.optionals withGputils [
    gputils
  ];

  configureFlags = let
    excludedPorts = excludePorts
                    ++ (lib.optionals (!withGputils) [ "pic14" "pic16" ]);
  in
    map (f: "--disable-${f}-port") excludedPorts;

  preConfigure = ''
    if test -n "''${dontStrip-}"; then
      export STRIP=none
    fi
  '';

  meta = {
    homepage = "https://sdcc.sourceforge.net/";
    description = "Small Device C Compiler";
    longDescription = ''
      SDCC is a retargettable, optimizing ANSI - C compiler suite that targets
      the Intel MCS51 based microprocessors (8031, 8032, 8051, 8052, etc.),
      Maxim (formerly Dallas) DS80C390 variants, Freescale (formerly Motorola)
      HC08 based (hc08, s08) and Zilog Z80 based MCUs (z80, z180, gbz80, Rabbit
      2000/3000, Rabbit 3000A). Work is in progress on supporting the Microchip
      PIC16 and PIC18 targets. It can be retargeted for other microprocessors.
    '';
    license = if withGputils
              then lib.licenses.unfreeRedistributable
              else lib.licenses.gpl2Plus;
    mainProgram = "sdcc";
    maintainers = with lib.maintainers; [ bjornfor yorickvp ];
    platforms = lib.platforms.all;
  };
})
