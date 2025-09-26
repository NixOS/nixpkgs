{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  cadical,
  cmake,
  flex,
  makeWrapper,
  perl,
  replaceVars,
  cudd,
  nix-update-script,
  fetchpatch,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cbmc";
  version = "6.7.1";

  src = fetchFromGitHub {
    owner = "diffblue";
    repo = "cbmc";
    tag = "cbmc-${finalAttrs.version}";
    hash = "sha256-GUY4Evya0GQksl0R4b01UDSvoxUEOOeq4oOIblmoF5o=";
  };

  srcglucose = fetchFromGitHub {
    owner = "brunodutertre";
    repo = "glucose-syrup";
    rev = "0bb2afd3b9baace6981cbb8b4a1c7683c44968b7";
    hash = "sha256-+KrnXEJe7ApSuj936T615DaXOV+C2LlRxc213fQI+Q4=";
  };

  srccadical =
    (cadical.override {
      version = "2.0.0";
    }).src;

  nativeBuildInputs = [
    bison
    cmake
    flex
    perl
    makeWrapper
  ];

  patches = [
    (replaceVars ./0001-Do-not-download-sources-in-cmake.patch {
      cudd = cudd.src;
    })
    ./0002-Do-not-download-sources-in-cmake.patch
  ];

  postPatch = ''
    # fix library_check.sh interpreter error
    patchShebangs .

    mkdir -p srccadical
    cp -r ${finalAttrs.srccadical}/* srccadical

    mkdir -p srcglucose
    cp -r ${finalAttrs.srcglucose}/* srcglucose
    find -exec chmod +w {} \;

    substituteInPlace src/solvers/CMakeLists.txt \
     --replace-fail "@srccadical@" "$PWD/srccadical" \
     --replace-fail "@srcglucose@" "$PWD/srcglucose"
  ''
  + lib.optionalString (!stdenv.cc.isGNU) ''
    # goto-gcc rely on gcc
    substituteInPlace "regression/CMakeLists.txt" \
      --replace-fail "add_subdirectory(goto-gcc)" ""
  '';

  postInstall = ''
    # goto-cc expects ls_parse.py in PATH
    mkdir -p $out/share/cbmc
    mv $out/bin/ls_parse.py $out/share/cbmc/ls_parse.py
    chmod +x $out/share/cbmc/ls_parse.py
    wrapProgram $out/bin/goto-cc \
      --prefix PATH : "$out/share/cbmc" \
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      # fix "argument unused during compilation"
      "-Wno-unused-command-line-argument"
      # fix "variable 'plus_overflow' set but not used"
      "-Wno-error=unused-but-set-variable"
      # fix "passing no argument for the '...' parameter of a variadic macro is a C++20 extension"
      "-Wno-error=c++20-extensions"
    ]
  );

  # TODO: add jbmc support
  cmakeFlags = [
    "-DWITH_JBMC=OFF"
    "-Dsat_impl=cadical"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/cbmc";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "cbmc-(.*)"
    ];
  };

  meta = {
    description = "Bounded Model Checker for C and C++ programs";
    homepage = "http://www.cprover.org/cbmc/";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ jiegec ];
    platforms = lib.platforms.unix;
  };
})
