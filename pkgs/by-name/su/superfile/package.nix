{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
let
  version = "1.3.0";
  tag = "v${version}";
in
buildGoModule {
  pname = "superfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    inherit tag;
    hash = "sha256-w2YAk5/5FJNet1INHCjr35QqPuCbXRo07za8WkR3hiA=";
  };

  vendorHash = "sha256-83Vxh9RFYUMOuvtWVAsF2mlcvyU8BlBxZDWQhoj67UU=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

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
