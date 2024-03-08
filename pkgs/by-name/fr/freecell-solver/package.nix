{ lib
, stdenv
, fetchurl
, cmake
, cmocka
, gmp
, gperf
, libtap
, ninja
, perl
, pkg-config
, python3
, rinutils
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freecell-solver";
  version = "6.8.0";

  src = fetchurl {
    url = "https://fc-solve.shlomifish.org/downloads/fc-solve/freecell-solver-${finalAttrs.version}.tar.xz";
    hash = "sha256-lfeKSxXS+jQCcf5PzFNUBlloGRuiLbDUDoGykbjVPTI=";
  };

  outputs = [ "out" "dev" "doc" "man" ];

  pythonPath = with python3.pkgs; [
    cffi
    pysol-cards
    random2
    six
  ];

  nativeBuildInputs = [
    cmake
    cmocka
    gperf
    ninja
    perl
    pkg-config
    python3
  ]
  ++ (with perl.pkgs; TaskFreecellSolverTesting.buildInputs ++ [
    GamesSolitaireVerify
    HTMLTemplate
    Moo
    PathTiny
    StringShellQuote
    TaskFreecellSolverTesting
    TemplateToolkit
    TextTemplate
  ])
  ++ [ python3.pkgs.wrapPython ]
  ++ finalAttrs.pythonPath;

  buildInputs = [
    gmp
    libtap
    rinutils
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "FCS_WITH_TEST_SUITE" false) # needs freecell-solver
    (lib.cmakeBool "BUILD_STATIC_LIBRARY" false)
  ];

  postFixup = ''
    wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
  '';

  meta = {
    homepage = "https://fc-solve.shlomifish.org/";
    description = "A FreeCell automatic solver";
    longDescription = ''
      FreeCell Solver is a program that automatically solves layouts of Freecell
      and similar variants of Card Solitaire such as Eight Off, Forecell, and
      Seahaven Towers, as well as Simple Simon boards.
    '';
    license = lib.licenses.mit;
    mainProgram = "fc-solve";
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
