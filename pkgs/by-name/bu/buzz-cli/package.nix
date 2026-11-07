{
  cacert,
  fetchFromGitHub,
  lib,
  runCommand,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buzz-cli";
  # The CLI crates have no releases of their own (their crate version stays
  # 0.1.0 in every release): Buzz releases ship them with the desktop app, so
  # this follows Buzz Desktop releases (desktop-v* tags).
  version = "0.5.28";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz";
    tag = "desktop-v${finalAttrs.version}";
    hash = "sha256-NEsLQwcoQ2zTgznFgGFGNgYPnoclicNVycSEjl7I0Wo=";
  };

  cargoHash = "sha256-UQ8qNqoeDwkwhmVZebi++gb2GP61dr1Zv2QU9mJ6KJ8=";
  cargoBuildFlags = [ "--package=buzz-cli" ];
  cargoTestFlags = [ "--package=buzz-cli" ];

  # reqwest initializes its rustls client in tests and needs a CA bundle.
  nativeCheckInputs = [ cacert ];

  # Make darwin builds reproducible by disabling debug symbols in ring.
  # See: https://github.com/briansmith/ring/pull/2881
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace "$cargoDepsCopy"/source-registry-*/ring-0.17.14/build.rs \
      --replace-fail 'c.flag("-gfull")' 'c.flag("-g0")'
  '';

  preBuild = ''
    # Remap transient Nix build paths for reproducible output.
    export RUSTFLAGS="--remap-path-prefix=$NIX_BUILD_TOP=/build ''${RUSTFLAGS:-}"
    export NIX_CFLAGS_COMPILE="-ffile-prefix-map=$NIX_BUILD_TOP=/build ''${NIX_CFLAGS_COMPILE:-}"
  '';

  # No versionCheckHook: `buzz` has no --version flag.

  passthru = {
    # Also updates buzz-relay, which shares this source and cargoHash.
    updateScript = ./update.sh;
    # `buzz pack` works without a relay: a minimal persona pack validates and
    # inspects, and one that points at a missing persona file is rejected.
    tests.persona-pack = runCommand "buzz-cli-persona-pack" { } ''
      mkdir -p pack/.plugin pack/agents
      cat > pack/.plugin/plugin.json <<'EOF'
      {"id": "org.nixos.test", "name": "Test", "version": "1.0.0", "personas": ["agents/tester.persona.md"]}
      EOF
      cat > pack/agents/tester.persona.md <<'EOF'
      ---
      name: tester
      display_name: Tester
      description: Checks the package.
      ---
      You test the nixpkgs package.
      EOF
      buzz=${lib.getExe finalAttrs.finalPackage}
      grep -qxF Valid. <<<"$($buzz pack validate pack)"
      grep -q 'Display: Tester' <<<"$($buzz pack inspect pack)"
      sed -i s/tester.persona/missing.persona/ pack/.plugin/plugin.json
      # `! cmd` never fails a script under `set -e`; check the exit status directly.
      if $buzz pack validate pack; then
        echo "a pack whose persona file is missing must not validate" >&2
        exit 1
      fi
      touch $out
    '';
  };

  meta = {
    description = "Agent-first CLI for Buzz relay";
    homepage = "https://github.com/block/buzz";
    changelog = "https://github.com/block/buzz/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "buzz";
    maintainers = with lib.maintainers; [
      sebfried
      kleinbem
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
