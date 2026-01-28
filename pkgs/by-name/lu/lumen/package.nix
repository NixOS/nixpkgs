{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  perl,
  openssl,
  stdenv,
  apple-sdk_15,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lumen";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "jnsahaj";
    repo = "lumen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YXT6nQ1TtizbO7Gcas10yuY6XJJmeFLUeSoepEizb5Q=";
  };

  cargoHash = "sha256-ux8OaAyffjD801yoyyfq6eCBlNhq/gXh7caJ7L5fGjE=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  checkFlags = [
    # These tests require a git repository
    "--skip=vcs::git::tests::test_get_merge_base_returns_ancestor"
    "--skip=vcs::git::tests::test_working_copy_parent_ref_returns_head"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for AI-powered git commit messages, diff summaries, and code explanations";
    homepage = "https://github.com/jnsahaj/lumen";
    changelog = "https://github.com/jnsahaj/lumen/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ecklf ];
    mainProgram = "lumen";
  };
})
