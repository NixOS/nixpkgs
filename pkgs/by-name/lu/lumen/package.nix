{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lumen";
  version = "2.30.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jnsahaj";
    repo = "lumen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EoxMYlWHmuprjjhvj3GyCxGDIcT/d+JMda9j75pqs+k=";
  };

  cargoHash = "sha256-qTFRfy+Wutee5SbaMaqcYjXgr6xZKYYBIuyVA7jAGiY=";

  strictDeps = true;

  # use the non-vendored openssl
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # tests that require a git repository to run
  checkFlags = [
    "--skip=vcs::git::tests::test_get_merge_base_returns_ancestor"
    "--skip=vcs::git::tests::test_working_copy_parent_ref_returns_head"
  ];

  meta = {
    description = "Fast terminal diff viewer and code review TUI";
    homepage = "https://github.com/jnsahaj/lumen";
    changelog = "https://github.com/jnsahaj/lumen/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "lumen";
  };
})
