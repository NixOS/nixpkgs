{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
  exiftool,
  zoxide,
}:
buildGoModule (finalAttrs: {
  pname = "superfile";
  version = "1.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JETdQ42vGPnpviCAR29BSdBTG+huWRr5syN5NysnAlo=";
  };

  vendorHash = "sha256-d2Yo8fWJ2fj7RJrnktljY6TkEPq6Tnbdh2BM4DIAr0E=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ exiftool ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    # Upstream's TestZoxide initializes a go-zoxide client, which looks up the
    # zoxide binary on PATH (exec.LookPath). Without it, the test fails with
    # "zoxide initialization failed" on Linux.
    zoxide
  ];

  # New file panels open in $HOME; layout validation rejects empty directories
  # (cursor 0 with element count 0). Dotfiles are hidden by default, so use a
  # visible file to keep $HOME non-empty for TestLayout.
  preCheck = ''
    touch "$HOME/keep"
  '';

  # Upstream notes that this could be flaky, and it consistently fails for me.
  checkFlags = [
    "-skip=^TestReturnDirElement/Sort_by_Date$"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Only failing on nix darwin. I suspect this is due to the way
    # darwin handles file permissions.
    "-skip=^TestCompressSelectedFiles"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pretty fancy and modern terminal file manager";
    homepage = "https://github.com/yorukot/superfile";
    changelog = "https://github.com/yorukot/superfile/blob/${finalAttrs.src.tag}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      r4nmaru314
      redyf
    ];
    mainProgram = "superfile";
  };
})
