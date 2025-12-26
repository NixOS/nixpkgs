{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
  exiftool,
}:
let
  version = "1.3.3";
  tag = "v${version}";
in
buildGoModule {
  pname = "superfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    inherit tag;
    hash = "sha256-A1SWsBcPtGNbSReslp5L3Gg4hy3lDSccqGxFpLfVPrk=";
  };

  vendorHash = "sha256-sqt0BzJW1nu6gYAhscrXlTAbwIoUY7JAOuzsenHpKEI=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ exiftool ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

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
