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
let
  version = "1.4.0";
  tag = "v${version}";
in
buildGoModule {
  pname = "superfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    inherit tag;
    hash = "sha256-famFzCmernwgY70UIhJEbN2ERe4DMuSyf/DbM3e0LQA=";
  };

  vendorHash = "sha256-quobh++hsMbofbjXfquSzMgLtuLP3aLG+fcMnZiZ2Cg=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    exiftool
    zoxide
  ];

  # Upstream notes that this could be flaky, and it consistently fails for me.
  checkFlags = [
    "-skip=^TestReturnDirElement/Sort_by_Date$"
  ]
  ++ lib.optionals stdenv.isDarwin [
    # Only failing on nix darwin. I suspect this is due to the way
    # darwin handles file permissions.
    "-skip=^TestCompressSelectedFiles"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pretty fancy and modern terminal file manager";
    homepage = "https://github.com/yorukot/superfile";
    changelog = "https://github.com/yorukot/superfile/blob/${tag}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      momeemt
      redyf
    ];
    mainProgram = "superfile";
  };
}
