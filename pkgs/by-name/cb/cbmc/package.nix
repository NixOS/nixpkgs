{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  bison,
  cadical,
  cbmc,
  cmake,
  flex,
  makeWrapper,
  perl,
  substituteAll,
  substitute,
  cudd,
  fetchurl,
  nix-update-script,
  apple-sdk,
  apple-sdk_10_15,
  darwinMinVersionHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cbmc";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "diffblue";
    repo = "cbmc";
    rev = "refs/tags/cbmc-${finalAttrs.version}";
    hash = "sha256-PZZnseOE3nodE0zwyG+82gm55BO4rsCcP4T+fZq7L6I=";
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

  buildInputs =
    [ cadical ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (darwinMinVersionHook "10.15")
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && lib.versionOlder apple-sdk.version "10.15") [
      apple-sdk_10_15
    ];

  # do not download sources
  # link existing cadical instead
  patches = [
    (substituteAll {
      src = ./0001-Do-not-download-sources-in-cmake.patch;
      inherit cudd;
    })
    ./0002-Do-not-download-sources-in-cmake.patch
  ];

  postPatch =
    ''
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
    lib.optionals stdenv.cc.isGNU [
      # Needed with GCC 12 but breaks on darwin (with clang)
      "-Wno-error=maybe-uninitialized"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      # fix "argument unused during compilation"
      "-Wno-unused-command-line-argument"
    ]
  );

  # TODO: add jbmc support
  cmakeFlags = [
    "-DWITH_JBMC=OFF"
    "-Dsat_impl=cadical"
    "-Dcadical_INCLUDE_DIR=${cadical.dev}/include"
  ];

  passthru.tests.version = testers.testVersion {
    package = cbmc;
    command = "cbmc --version";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CBMC is a Bounded Model Checker for C and C++ programs";
    homepage = "http://www.cprover.org/cbmc/";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ jiegec ];
    platforms = lib.platforms.unix;
  };
})
