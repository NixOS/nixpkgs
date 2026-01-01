{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  nix-update-script,
<<<<<<< HEAD
  rust-jemalloc-sys,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.67.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    tag = finalAttrs.version;
    hash = "sha256-AgY/v1z4ETHawT+yEwTEaPOLC9GmhR8bGUUBKHY/meQ=";
  };

  cargoHash = "sha256-TTg5Cky1exlvJokIw1IFGbPq4eJe2xSAPsGgI7BU+Jw=";

<<<<<<< HEAD
  buildInputs = [ rust-jemalloc-sys ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  env = lib.optionalAttrs stdenv.hostPlatform.isStatic { RUSTFLAGS = "-C relocation-model=static"; };

  # skip flaky tests
  checkFlags = [ "--skip=options::tests::test_detect_display_width" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/difft";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ethancedwards8
      matthiasbeyer
      defelo
    ];
    mainProgram = "difft";
  };
})
