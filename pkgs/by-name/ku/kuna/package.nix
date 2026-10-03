{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  testers,
  callPackage,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kuna";
  version = "1.624";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Noelo-Lab";
    repo = "kuna";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FI0YxHUg5LfXFFFyj8YLzOZ0M9R98EXI4TJpYQGkQ9k=";
  };

  # Adapt CLI tests to Nix's ELF loader and newer C compiler diagnostics.
  patches = [ ./cli-test-portability.patch ];

  cargoHash = "sha256-o1Z92td5+oK3935rNS33UWXDYBWXcNGViFQU6ktGt9A=";
  cargoRoot = "decompiler";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  env.KUNA_VERSION = finalAttrs.version;
  env.CARGO_PROFILE_TEST_DEBUG = "0";

  nativeBuildInputs = [ makeBinaryWrapper ];

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

  # This test recompiles a function incorrectly decompiled as void instead of int.
  # Nix's hardening clears the leftover return value, so the output comparison fails.
  checkFlags = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
    "--skip=an_element_pointer_round_trips_through_the_printed_c"
  ];

  preCheck = ''
    export KUNA_ROOT="$PWD"
    export SLEIGHHOME="$PWD/specs"
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
