{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  python3,
  testers,
  callPackage,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kuna";
  version = "1.740";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Noelo-Lab";
    repo = "kuna";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xRnMpadHh+BWFXNA5iHkieSyt5RZu/J/ieDrexXOdAc=";
  };

  # Adapt CLI tests to Nix's ELF loader and C toolchain.
  patches = [ ./cli-test-portability.patch ];

  cargoHash = "sha256-QVuEGGzuk+HfZA43Z7cRzqt08DbVZcaYqmsXxId9vFo=";
  cargoRoot = "decompiler";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  env.KUNA_VERSION = finalAttrs.version;
  env.CARGO_PROFILE_TEST_DEBUG = "0";

  nativeBuildInputs = [ makeBinaryWrapper ];

  nativeCheckInputs = [ python3 ];

  cargoBuildFlags = [
    "-p"
    "kuna-cli"
    "-p"
    "kuna-console"
    "-p"
    "kuna-slacomp"
    "-p"
    "kuna-harness"
  ];

  postBuild =
    let
      slacomp =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "target/${stdenv.hostPlatform.rust.rustcTarget}/release/slacomp"
        else
          "${buildPackages.kuna}/bin/slacomp";
    in
    ''
      ${slacomp} -a specs
    '';

  cargoTestFlags = [
    "--workspace"
    "--no-fail-fast"
  ];

  # Upstream's test profile enables overflow checks and debug assertions.
  checkType = "debug";

  preCheck = ''
    export KUNA_ROOT="$PWD"
    export SLEIGHHOME="$PWD/specs"
    # -O0 fixture builds trigger a _FORTIFY_SOURCE warning with Nix's C flags.
    export NIX_CFLAGS_COMPILE+=" -Wno-error=cpp"
  ''
  + lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) ''
    export KUNA_TEST_LD_SO=${stdenv.cc.bintools.dynamicLinker}
  '';

  postInstall = ''
    mkdir -p $out/share/kuna/tests
    cp -r specs $out/share/kuna/
    cp -r tests/datatests $out/share/kuna/tests/
    install -Dm644 -t $out/share/licenses/kuna LICENSE NOTICE

    wrapProgram $out/bin/kuna \
      --set-default KUNA_ROOT $out/share/kuna
    for program in decomp_dbg decomp_test_dbg; do
      wrapProgram $out/bin/$program \
        --set-default SLEIGHHOME $out/share/kuna/specs
    done
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
      smoke = callPackage ./tests.nix { kuna = finalAttrs.finalPackage; };
    };
  };

  meta = {
    description = "Agent-first binary decompiler based on Ghidra";
    homepage = "https://kuna.noelo.org";
    changelog = "https://github.com/Noelo-Lab/kuna/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ connornelson ];
    mainProgram = "kuna";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
