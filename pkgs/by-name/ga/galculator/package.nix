{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  fetchpatch2,
  flex,
  gtk3,
  intltool,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "galculator";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "galculator";
    repo = "galculator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XLDQdUGin7b9SgYV1kwMChBF+l0mYc9sAscY4YRZEGA=";
  };

  patches = [
    # Pul patch pending upstream inclusion for -fno-common toolchain support:
    #   https://github.com/galculator/galculator/pull/45
    (fetchpatch2 {
      name = "fno-common.patch";
      url = "https://github.com/galculator/galculator/commit/501a9e3feeb2e56889c0ff98ab6d0ab20348ccd6.patch";
      hash = "sha256-qVJHcfJTtl0hK8pzSp6MjhYAh1NbIIWr3rBDodIYBvk=";
    })
    ./gettext-0.25.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    flex
    intltool
    pkg-config
  ];

  buildInputs = [
    gtk3
  ];

  # BUG: when set as true, complains with:
  # configure.in:76: error: possibly undefined macro: AM_GLIB_GNU_GETTEXT
  strictDeps = false;

  meta = {
    homepage = "https://galculator.sourceforge.net/";
    description = "GTK algebraic and RPN calculator";
    longDescription = ''
      galculator is a GTK-based calculator. Its main features include:

      - Algebraic, RPN (Reverse Polish Notation), Formula Entry and Paper modes;
      - Basic and Scientific Modes
      - Decimal, hexadecimal, octal and binary number base
      - Radiant, degree and grad support
      - User defined constants and functions
      - A bunch of common functions
      - Binary arithmetic of configurable bit length and signedness
      - Quad-precision floating point arithmetic, and 112-bit binary arithmetic
    '';
    license = lib.licenses.gpl2Plus;
    mainProgram = "galculator";
    maintainers = with lib.maintainers; [ ];
    inherit (gtk3.meta) platforms;
  };
})
