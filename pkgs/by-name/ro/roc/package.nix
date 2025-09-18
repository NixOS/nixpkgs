{
  lib,
  stdenv,
  fetchFromGitHub,
  libffi,
  libxml2,
  makeBinaryWrapper,
  cmake,
  glibc,
  rustPlatform,
  zig_0_13,
  llvmPackages_18,
  writableTmpDirAsHomeHook,
  valgrind,
  autoPatchelfHook,
}:

let
  llvmPackages = llvmPackages_18;
  rocVersion = "alpha4";
in

rustPlatform.buildRustPackage rec {
  pname = "roc";
  version = "0-${rocVersion}";

  src = fetchFromGitHub {
    owner = "roc-lang";
    repo = "roc";
    rev = "d73ea109cc21442da01387c1e5e911607c74692d";
    hash = "sha256-pPnOM4hpbAkGCV47aw5eHbpOujjFtJa3v/3/D8gybO8=";
  };

  nativeBuildInputs = [
    cmake
    zig_0_13
  ]
  ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    libffi
    libxml2
    llvmPackages.clang
    llvmPackages.llvm.dev
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.isLinux [
    glibc
    stdenv.cc.cc.lib
  ];

  cargoHash = "sha256-wJViSHcezoIchWe4Py9j+9U+YJUA5ja/x94UipuWO2g=";

  # prevents zig AccessDenied error github.com/ziglang/zig/issues/6810
  XDG_CACHE_HOME = "xdg_cache";

  preBuild =
    let
      llvmVersion = builtins.splitVersion llvmPackages.release_version;
      llvmMajorMinorStr = builtins.elemAt llvmVersion 0 + "0";
    in
    ''
      export LLVM_SYS_${llvmMajorMinorStr}_PREFIX=${llvmPackages.llvm.dev}
    '';

  postInstall =
    lib.optionalString stdenv.isLinux ''
      wrapProgram $out/bin/roc \
        --set NIX_GLIBC_PATH ${glibc.out}/lib \
        --set NIX_LIBGCC_S_PATH ${stdenv.cc.cc.lib}/lib \
        --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
    ''
    + lib.optionalString (!stdenv.isLinux) ''
      wrapProgram $out/bin/roc --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
    '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    llvmPackages.clang
    valgrind
  ];

  checkPhase =
    lib.optionalString stdenv.isLinux ''
      runHook preCheck
      NIX_GLIBC_PATH=${glibc.out}/lib NIX_LIBGCC_S_PATH=${stdenv.cc.cc.lib}/lib cargo test --release --workspace --exclude test_mono --exclude uitest -- --skip glue_cli_tests
      runHook postCheck
    ''
    + lib.optionalString (!stdenv.isLinux) ''
      runHook preCheck
      cargo test --release --workspace --exclude test_mono --exclude uitest -- --skip glue_cli_tests
      runHook postCheck
    '';

  meta = {
    description = "Fast, friendly, functional programming language";
    mainProgram = "roc";
    homepage = "https://www.roc-lang.org/";
    changelog = "https://github.com/roc-lang/roc/releases/tag/${rocVersion}";
    license = lib.licenses.upl;
    maintainers = [
      lib.maintainers.anton-4
      lib.maintainers.bhansconnect
      lib.maintainers.rtfeldman
    ];
    platforms = [ "x86_64-linux" ];
  };
}
