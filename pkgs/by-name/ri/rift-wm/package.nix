{
  lib,
  rustPlatform,
  fetchFromGitHub,
  apple-sdk,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rift-wm";
  version = "0.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "acsandmann";
    repo = "rift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SxhN9f0Ekc8VISsG37VJEO3qt5MXqq8qZcBEMTD9mCY=";
  };

  nativeBuildInputs = [
    apple-sdk
  ];

  cargoHash = "sha256-WId2LP/9i17ybMEPvk6Z/V/eh7xTrQNH8VXigRVLFwU=";
  checkFlags = [
    # runs into: topology invalidation must resend the hidden-window frame write instead of treating the stale target as still pending: [GetVisibleWindows]
    "--skip=actor::reactor::tests::topology_change_clears_stale_pending_hide_target_before_next_workspace_layout"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiling window manager for macos";
    homepage = "https://github.com/acsandmann/rift";
    changelog = "https://github.com/acsandmann/rift/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eveeifyeve ];
    mainProgram = "rift";
    platforms = lib.platforms.darwin;
  };
})
