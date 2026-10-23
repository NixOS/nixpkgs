{
  lib,
  stdenv,
  fetchurl,
  bison,
  boost,
  flex,
  gputils,
  zlib,
  withGputils ? false,
  excludePorts ? [ ],
}:

assert
  lib.subtractLists [
    "ds390"
    "ds400"
    "ez80"
    "f8"
    "f8l"
    "hc08"
    "mcs51"
    "mos6502"
    "mos65c02"
    "pdk13"
    "pdk14"
    "pdk15"
    "pic14"
    "pic16"
    "r2k"
    "r2ka"
    "r3ka"
    "r4k"
    "r5k"
    "r6k"
    "r800"
    "s08"
    "sm83"
    "stm8"
    "tlcs90"
    "z180"
    "z80"
    "z80n"
  ] excludePorts == [ ];
stdenv.mkDerivation (finalAttrs: {
  pname = "sdcc";
  version = "4.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/sdcc/sdcc-src-${finalAttrs.version}.tar.bz2";
    hash = "sha256-X9apPlmXzgF1aGj+NeRBCVz7Y3iUqAwmJRSmNAlJc7Y=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  # support/cpp is a gcc snapshot, which does not build with format hardening.
  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    bison
    flex
  ]
  ++ lib.optionals withGputils [
    # gpasm, gplink and gplib assemble and link the pic14/pic16 device libraries
    gputils
  ];

  buildInputs = [
    boost
    zlib
  ];

  configureFlags =
    let
      excludedPorts =
        excludePorts
        ++ (lib.optionals (!withGputils) [
          "pic14"
          "pic16"
        ]);
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
      SDCC is a free open source, retargettable, optimizing ISO C compiler suite
      that targets a growing list of processors including the Intel MCS-51 based
      microprocessors (8031, 8032, 8051, 8052, etc.), Maxim (formerly Dallas)
      DS80C390 variants, Freescale (formerly Motorola) HC08 based (hc08, s08),
      Zilog Z80 based MCUs (Z80, Z80N, Z180, SM83 (e.g. Game Boy), Rabbit 2000,
      Rabbit 2000A/3000, Rabbit 3000A, TLCS-90, R800), STMicroelectronics STM8,
      Padauk PDK14 and PDK15 and MOS 6502. Work is in progress on supporting the
      Padauk PDK13 target. There are unmaintained Microchip PIC16 and PIC18
      targets. It can be retargeted for other microprocessors.
    '';
    license = if withGputils then lib.licenses.unfreeRedistributable else lib.licenses.gpl2Plus;
    mainProgram = "sdcc";
    maintainers = with lib.maintainers; [
      bjornfor
      yorickvp
    ];
    platforms = lib.platforms.all;
  };
})
