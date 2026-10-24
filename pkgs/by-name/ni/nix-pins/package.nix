{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  bash,
  git,
  nix,
  path,
  libiconv,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-pins";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ercao";
    repo = "nix-pins";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tcLTSMvYyiXDNxU2bfJGDMa80mhAViTSFjbsx+vhpS8=";
  };

  cargoHash = "sha256-c/gbQq5QFJLUTBHoT4BGadvtA8Ag2a5ogWIvVXp8KYU=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  env.NIX_PINS_EVALUATOR = "${placeholder "out"}/share/nix-pins/nix/evaluator.nix";

  postPatch = ''
    # These scripts are generated at test runtime, after patchShebangs runs.
    substituteInPlace crates/cli/tests/cli.rs \
      --replace-fail '#!/bin/sh' '#!${stdenv.shell}'
  '';

  nativeCheckInputs = [
    git
    nix
  ];

  preCheck = ''
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    export NIX_REMOTE="local?root=$TMPDIR/nix-store"
    export NIX_PATH="nixpkgs=${lib.cleanSource path}"
    export NIX_CONFIG=$'experimental-features = nix-command flakes\nsubstituters =\nbuild-users-group ='
  '';

  # HTTP checker tests use a loopback server.
  __darwinAllowLocalNetworking = true;

  checkFlags = [
    "--test-threads=1"
    # These probes fetch real upstream sources and dependencies.
    "--skip=probe::tests::orthogonal_git_and_url_fetchers_evaluate_through_the_public_nix_seam"
    "--skip=probe::tests::probes_real_github_go_and_npm_derivations"
  ];

  postInstall = ''
    mkdir -p $out/share/nix-pins
    cp -R nix $out/share/nix-pins/
  '';

  postFixup = ''
    wrapProgram $out/bin/nix-pins --suffix PATH : ${
      lib.makeBinPath [
        bash
        git
        nix
      ]
    }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lock source and dependency hashes for Nix packages";
    homepage = "https://github.com/ercao/nix-pins";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ercao ];
    mainProgram = "nix-pins";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
