{
  stdenv,
  fetchFromGitHub,
  lib,
  zlib,
  libffi,
  libxml2,
  llvmPackages_21,
  ncurses,
  darwin,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "ante";
  version = "0-unstable-2026-08-11";
  src = fetchFromGitHub {
    owner = "jfecher";
    repo = "ante";
    rev = "626094eaa9e94654b0511194a0ecccfd962116cc";
    fetchSubmodules = true;
    hash = "sha256-cDeSp78WMzzlZIcdHkr+mns3iQtCyIh8aP3qaRAAax0=";
  };

  cargoHash = "sha256-b2vGeOLGCmKkhTbDLrtzEcISvE5IGymqECkk57seXSE=";

  strictDeps = true;

  nativeBuildInputs = [ llvmPackages_21.llvm ];
  buildInputs = [
    zlib
    libffi
    libxml2
    ncurses
  ];

  preBuild =
    let
      major = lib.versions.major llvmPackages_21.llvm.version;
      minor = lib.versions.minor llvmPackages_21.llvm.version;
      llvm-sys-ver = "${major}${builtins.substring 0 1 minor}";
    in
    ''
      # On some architectures llvm-sys is not using the package listed inside nativeBuildInputs
      export LLVM_SYS_${llvm-sys-ver}_PREFIX=${llvmPackages_21.llvm.dev}

      export ANTE_MINICORO_PATH=$out/lib/aminicoro/minicoro.c
      mkdir -p $out/lib/aminicoro
      cp -r $src/aminicoro/* $out/lib/aminicoro

      export ANTE_STDLIB_DIR=$out/lib/stdlib
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

  meta = {
    homepage = "https://antelang.org/";
    description = "Low-level functional language for exploring refinement types, lifetime inference, and algebraic effects";
    mainProgram = "ante";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ehllie ];
  };
}
