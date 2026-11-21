{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  swig,
  unixodbc,
  python3Packages,
  ctestCheckHook,
  pythonSupport ? true,
  withODBC ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "agrum";
  version = "3.3.2";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "agrumery";
    repo = "aGrUM";
    tag = finalAttrs.version;
    hash = "sha256-rPFs0xIpcXfHW5ZcYdGOGLEcG/aVoW20sOGl+JqObEQ=";
  };

  # Tests that fail because error messages get a "[pyAgrum] ..." prefix.
  postPatch = lib.optionalString pythonSupport ''
    substituteInPlace src/cmake/doctest.agrum.cmake \
      --replace-fail "COMMAND gumTest)" \
        "COMMAND gumTest --test-case-exclude=*MicroSystemWithError6,*UnassignedReferenceSlotInsideASlotChain)"
  '';

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals pythonSupport [
    swig
    python3Packages.python
    python3Packages.pythonImportsCheckHook
  ];

  buildInputs =
    lib.optionals withODBC [ unixodbc ]
    ++ lib.optionals pythonSupport [
      python3Packages.python
      python3Packages.numpy
    ];

  propagatedBuildInputs = lib.optionals pythonSupport (
    with python3Packages;
    [
      ipython
      matplotlib
      matplotlib-inline
      numpy
      pydot
      scikit-learn
    ]
  );

  cmakeFlags = [
    (lib.cmakeBool "USE_NANODBC" withODBC)
    (lib.cmakeBool "BUILD_PYTHON" pythonSupport)
  ];

  # The C++ test suite is excluded from the default target.
  buildFlags = [ "all" ] ++ lib.optionals finalAttrs.doCheck [ "gumTest" ];

  doCheck = true;

  nativeCheckInputs = [
    ctestCheckHook
  ]
  ++ lib.optionals pythonSupport (
    with python3Packages;
    [
      pandas
      scipy
    ]
  );

  # ctest overrides PYTHONPATH for python_quick; nixpkgs' python also reads NIX_PYTHONPATH.
  preCheck = ''
    export NIX_PYTHONPATH=$PYTHONPATH
  '';

  pythonImportsCheck = [
    "pyagrum"
    "pyagrum.causal_model"
    "pyagrum.credal_net"
    "pyagrum.influence_diagram"
    "pyagrum.markov_random_field"
    "pyagrum.prm"
    "pyagrum.ktbn"
    "pyagrum.causal"
  ];

  meta = {
    description = "C++ library for graphical models";
    longDescription = ''
      aGrUM is a C++ library for graphical models. It is designed for easily
      building applications using graphical models such as Bayesian networks,
      influence diagrams, credal networks, Markov random fields, decision trees,
      GAI networks, (Factored) Markov decision processes, etc.
    '';
    homepage = "https://pyagrum.gitlab.io/";
    changelog = "https://gitlab.com/agrumery/aGrUM/-/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      lgpl3Plus
      mit
    ];
    maintainers = with lib.maintainers; [ haansn08 ];
    platforms = lib.platforms.unix;
  };
})
