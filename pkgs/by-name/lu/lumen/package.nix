{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  openssl,
  fzf,
  mdcat,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lumen";
  version = "2.32.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jnsahaj";
    repo = "lumen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wTkg7NGCCON1P422q5/76rodIBqDeWIY07J4pRo8Q8k=";
  };

  cargoHash = "sha256-ZXw7KEvf1sUHWIM5R4Th2SmekTX6rGXznAq3mtcf3Zo=";

  strictDeps = true;

  # use the non-vendored openssl
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [ openssl ];

  postFixup = ''
    wrapProgram $out/bin/lumen --prefix PATH : ${
      lib.makeBinPath [
        fzf
        mdcat
      ]
    }
  '';

  # tests that require a git repository to run
  checkFlags = [
    "--skip=vcs::git::tests::test_get_merge_base_returns_ancestor"
    "--skip=vcs::git::tests::test_working_copy_parent_ref_returns_head"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast terminal diff viewer and code review TUI";
    homepage = "https://github.com/jnsahaj/lumen";
    changelog = "https://github.com/jnsahaj/lumen/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "lumen";
  };
})
