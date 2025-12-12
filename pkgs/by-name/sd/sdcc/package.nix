{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  bison,
  boost,
  flex,
  gputils,
  texinfo,
  zlib,
  withGputils ? false,
  excludePorts ? [ ],
}:

assert
  lib.subtractLists [
    "ds390"
    "ds400"
    "gbz80"
    "hc08"
    "mcs51"
    "pic14"
    "pic16"
    "r2k"
    "r3ka"
    "s08"
    "stm8"
    "tlcs90"
    "z80"
    "z180"
  ] excludePorts == [ ];
stdenv.mkDerivation (finalAttrs: {
  pname = "sdcc";
  version = "4.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/sdcc/sdcc-src-${finalAttrs.version}.tar.bz2";
    hash = "sha256-1QMEN/tDa7HZOo29v7RrqqYGEzGPT7P1hx1ygV0e7YA=";
  };

  # TODO: sdcc version 4.5.0 does not currently produce a man output.
  # Until the fix to sdcc's makefiles is released, this workaround
  # conditionally withholds the man output on darwin.
  #
  # sdcc's tracking issue:
  # <https://sourceforge.net/p/sdcc/bugs/3848/>
  outputs = [
    "out"
    "doc"
  ]
  ++ lib.optionals (!stdenv.isDarwin) [
    "man"
  ];

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
  ]
  ++ lib.optionals withGputils [
    gputils
  ];

  # sdcc 4.5.0 massively rewrote sim/ucsim/Makefile.in, and lost the `.PHONY`
  # rule in the process. As a result, on macOS (which uses a case-insensitive
  # filesystem), the INSTALL file keeps the `install` target in the ucsim
  # directory from running. Nothing else creates the `man` output, causing the
  # entire build to fail.
  #
  # TODO: remove this when updating to the next release - it's been fixed in
  # upstream sdcc r15384 <https://sourceforge.net/p/sdcc/code/15384/>.

  postPatch = ''
    if grep -q '\.PHONY:.*install' sim/ucsim/Makefile.in; then
      echo 'Upstream has added `.PHONY: install` rule; must remove `postPatch` from the Nix file.' >&2
      exit 1
    fi
    echo '.PHONY: install' >> sim/ucsim/Makefile.in
  '';

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
      SDCC is a retargettable, optimizing ANSI - C compiler suite that targets
      the Intel MCS51 based microprocessors (8031, 8032, 8051, 8052, etc.),
      Maxim (formerly Dallas) DS80C390 variants, Freescale (formerly Motorola)
      HC08 based (hc08, s08) and Zilog Z80 based MCUs (z80, z180, gbz80, Rabbit
      2000/3000, Rabbit 3000A). Work is in progress on supporting the Microchip
      PIC16 and PIC18 targets. It can be retargeted for other microprocessors.
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
