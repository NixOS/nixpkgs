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
  version = "1.980";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Noelo-Lab";
    repo = "kuna";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tp0eYpNCVYIo4eHuPC068xAsOHKRRNMdWSjMUfA6u3s=";
  };

  # Run bundled ELF fixtures with Nix's dynamic loader.
  patches = [ ./cli-test-portability.patch ];

  cargoHash = "sha256-YgszQlq5uhmKqbgqpvbX/ox2Jtm3GB8QND61DB/Tohs=";
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
  useNextest = true;

  checkFlags =
    lib.concatMap
      (name: [
        "--skip"
        name
      ])
      [
        # Upstream decompiler bugs exposed by Nix's register-clearing hardening.
        "float_unordered_compare::float_compare_flags_keep_their_unordered_case"
        "saved_xmm_msabi::saved_xmm_spills_are_not_emitted_as_live_locals"
        "project_named_globals::named_scalars_are_declared_at_the_type_the_bodies_read_them"
        # Kuna does not apply DWARF relocations in the unlinked object fixture.
        "locked_scalar_declarations::dwarf_function_pointer_local_keeps_its_declaration"
        # The freestanding 32-bit harness has incorrect stack alignment.
        "wrapped_stack_aggregate::wrapped_struct_spills_preserve_callback_memory_effects"
      ];

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
    web = callPackage ./web.nix { kuna = finalAttrs.finalPackage; };
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
