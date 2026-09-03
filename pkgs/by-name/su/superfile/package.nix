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
  version = "1.6.0";
  tag = "v${version}";
in
buildGoModule {
  pname = "superfile";
  inherit version;

  src = fetchFromGitHub {
    owner = "yorukot";
    repo = "superfile";
    inherit tag;
    hash = "sha256-JETdQ42vGPnpviCAR29BSdBTG+huWRr5syN5NysnAlo=";
  };

  vendorHash = "sha256-d2Yo8fWJ2fj7RJrnktljY6TkEPq6Tnbdh2BM4DIAr0E=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ exiftool ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # Headless sandbox tests fail due to missing interactive zoxide/TUI environment.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pretty fancy and modern terminal file manager";
    homepage = "https://github.com/yorukot/superfile";
    changelog = "https://github.com/yorukot/superfile/blob/${tag}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      redyf
    ];
    mainProgram = "superfile";
  };
}
