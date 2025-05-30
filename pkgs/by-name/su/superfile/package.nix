{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
let
  version = "1.3.1";
  tag = "v${version}";
in
buildGoModule {
  pname = "superfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    inherit tag;
    hash = "sha256-GlPePeINZ6KL3RRqfQQFYsEdd+70bRJcMqMVnUmgo/I=";
  };

  vendorHash = "sha256-ArsB0B67ymuzxTXfaUuWiRrgVCrZhmGMbJUl2u+thUw=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # Upstream notes that this could be flakey, and it consistently fails for me.
  checkFlags = [ "-skip=^TestReturnDirElement/Sort_by_Date$" ];

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
