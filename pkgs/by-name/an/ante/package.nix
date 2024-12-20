{
  fetchFromGitHub,
  lib,
  libffi,
  libxml2,
  llvmPackages_16,
  ncurses,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "ante";
  version = "unstable-2023-12-18";
  src = fetchFromGitHub {
    owner = "jfecher";
    repo = "ante";
    rev = "e38231ffa51b84a2ca53b4b0439d1ca5e0dea32a";
    hash = "sha256-UKEoOm+Jc0YUwO74Tn038MLeX/c3d2z8I0cTBVfX61U=";
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "inkwell-0.2.0" = "sha256-eMoclRtekg8v+m5KsTcjB3zCdPkcJy42NALEEuT/fw8=";
    };
  };

  /*
     https://crates.io/crates/llvm-sys#llvm-compatibility
     llvm-sys requires a specific version of llvmPackages,
     that is not the same as the one included by default with rustPlatform.
  */
  nativeBuildInputs = [ llvmPackages_16.llvm ];
  buildInputs = [
    libffi
    libxml2
    ncurses
  ];

  postPatch = ''
    substituteInPlace tests/golden_tests.rs --replace \
      'target/debug' "target/$(rustc -vV | sed -n 's|host: ||p')/release"
  '';
  preBuild =
    let
      major = lib.versions.major llvmPackages_16.llvm.version;
      minor = lib.versions.minor llvmPackages_16.llvm.version;
      llvm-sys-ver = "${major}${builtins.substring 0 1 minor}";
    in
    ''
      # On some architectures llvm-sys is not using the package listed inside nativeBuildInputs
      export LLVM_SYS_${llvm-sys-ver}_PREFIX=${llvmPackages_16.llvm.dev}
      export ANTE_STDLIB_DIR=$out/lib
      mkdir -p $ANTE_STDLIB_DIR
      cp -r $src/stdlib/* $ANTE_STDLIB_DIR
    '';

  meta = with lib; {
    homepage = "https://antelang.org/";
    description = "Low-level functional language for exploring refinement types, lifetime inference, and algebraic effects";
    mainProgram = "ante";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ehllie ];
  };
}
