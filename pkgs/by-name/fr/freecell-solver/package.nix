{
  lib,
  stdenv,
  fetchurl,
  cmake,
  cmocka,
  gmp,
  gperf,
  ninja,
  perl,
  pkg-config,
  python3,
  rinutils,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freecell-solver";
  version = "6.16.0";

  src = fetchurl {
    url = "https://fc-solve.shlomifish.org/downloads/fc-solve/freecell-solver-${finalAttrs.version}.tar.xz";
    hash = "sha256-cbiILmjxvmJSkGkBjQxzK3UHhmkHfJY0gnlXWEnzQxM=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

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
  ++ (
    with perl.pkgs;
    TaskFreecellSolverTesting.buildInputs
    ++ [
      GamesSolitaireVerify
      HTMLTemplate
      Moo
      PathTiny
      StringShellQuote
      TaskFreecellSolverTesting
      TemplateToolkit
      TextTemplate
    ]
  )
  ++ [ python3.pkgs.wrapPython ]
  ++ finalAttrs.pythonPath;

  buildInputs = [
    gmp
    rinutils
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "FCS_WITH_TEST_SUITE" false) # needs freecell-solver
    (lib.cmakeBool "BUILD_STATIC_LIBRARY" false)
  ];

  preFixup = ''
    # This is a module and should not be wrapped, or it causes import errors
    # on the scripts that are actually executable
    chmod a-x $out/bin/fc_solve_find_index_s2ints.py
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/bin" "$out ''${pythonPath[*]}"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  postInstallCheck = ''
    # Check that the python wrappers work correctly:
    # * fc_solve_find_index_s2ints.py should be unwrapped (we get SyntaxError otherwise)
    # * the wrapper should provide all modules from the pythonPath (we get ModuleNotFoundError otherwise)
    # * we don't provide valid input so expect IndexError
    unset PYTHONPATH
    ($out/bin/make_pysol_freecell_board.py 2>&1 | tee /dev/stderr || true) | grep -q "IndexError:"
  '';
  doInstallCheck = true;

  __structuredAttrs = true;

  meta = {
    homepage = "https://fc-solve.shlomifish.org/";
    description = "FreeCell automatic solver";
    longDescription = ''
      FreeCell Solver is a program that automatically solves layouts of Freecell
      and similar variants of Card Solitaire such as Eight Off, Forecell, and
      Seahaven Towers, as well as Simple Simon boards.
    '';
    license = lib.licenses.mit;
    mainProgram = "fc-solve";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
