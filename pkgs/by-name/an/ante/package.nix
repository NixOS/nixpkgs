{
  stdenv,
  fetchFromGitHub,
  lib,
  zlib,
  libffi,
  libxml2,
  llvmPackages_18,
  ncurses,
  darwin,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "ante";
  version = "0-unstable-2025-07-12";
  src = fetchFromGitHub {
    owner = "jfecher";
    repo = "ante";
    rev = "e1f68f00937ae39badcc42a48c0078b608f294bf";
    fetchSubmodules = true;
    hash = "sha256-mbjV7S705bSseA/P31jiJiktpUEQ8hS+M4kcs2AM1/Y=";
  };

  cargoHash = "sha256-cRF1JFqWpGGQO3fIGcatVY1pp65CvNeM/6LFYDJxdpM=";

  strictDeps = true;

  nativeBuildInputs = [ llvmPackages_18.llvm ];
  buildInputs = [
    zlib
    libffi
    libxml2
    ncurses
  ];

  postPatch = ''
    substituteInPlace tests/golden_tests.rs --replace-fail \
      'target/debug' "target/$(rustc -vV | sed -n 's|host: ||p')/release"

    substituteInPlace src/util/mod.rs \
      --replace-fail '"gcc"' '"${lib.getExe llvmPackages_18.clang}"'
  '';
  preBuild =
    let
      major = lib.versions.major llvmPackages_18.llvm.version;
      minor = lib.versions.minor llvmPackages_18.llvm.version;
      llvm-sys-ver = "${major}${builtins.substring 0 1 minor}";
    in
    ''
      # On some architectures llvm-sys is not using the package listed inside nativeBuildInputs
      export LLVM_SYS_${llvm-sys-ver}_PREFIX=${llvmPackages_18.llvm.dev}
      export ANTE_STDLIB_DIR=$out/lib
      mkdir -p $ANTE_STDLIB_DIR
      cp -r $src/stdlib/* $ANTE_STDLIB_DIR
    '';
  # Ante uses the default LLVM target which, because we currently
  # don’t include a Darwin version in the target, seemingly defaults
  # to the host macOS version, which makes `ld(1)` warn about the
  # mismatching deployment targets, which breaks the tests.
  #
  # TODO: Remove this once it stops being necessary.
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export MACOSX_DEPLOYMENT_TARGET=$(
      ${lib.getExe' darwin.DarwinTools "sw_vers"} -productVersion
    )
  '';

  meta = with lib; {
    homepage = "https://antelang.org/";
    description = "Low-level functional language for exploring refinement types, lifetime inference, and algebraic effects";
    mainProgram = "ante";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ehllie ];
  };
}
