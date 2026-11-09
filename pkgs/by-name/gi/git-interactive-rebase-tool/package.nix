{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchpatch,
  pkg-config,
  libgit2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-interactive-rebase-tool";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "MitMaro";
    repo = "git-interactive-rebase-tool";
    rev = finalAttrs.version;
    hash = "sha256-NlnESZua4OP7rhMoER/VgBST9THqISQ0LCG1ZakNTqs=";
  };

  cargoPatches = [
    (fetchpatch {
      name = "update_git2_to_0.20.0.patch";
      url = "https://github.com/MitMaro/git-interactive-rebase-tool/commit/4f04527a23aca92675423aefe093247d87f05298.patch";
      hash = "sha256-XvX07x9p0gcs6FYChDpYDsp58LkrjTtw3M3Oyp7YetY=";
    })
  ];

  cargoHash = "sha256-D4X6INF7sPzfpmBTO84pnfqNlCot+JwZCtKJ64oPyHQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 ];

  # Compilation during tests fails if this env var is not set.
  preCheck = "export GIRT_BUILD_GIT_HASH=${finalAttrs.version}";
  postCheck = "unset GIRT_BUILD_GIT_HASH";

  meta = {
    homepage = "https://github.com/MitMaro/git-interactive-rebase-tool";
    description = "Native cross platform full feature terminal based sequence editor for git interactive rebase";
    changelog = "https://github.com/MitMaro/git-interactive-rebase-tool/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      SuperSandro2000
      zowoq
      ma27
    ];
    mainProgram = "interactive-rebase-tool";
  };
})
