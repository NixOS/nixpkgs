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

  # TestLayout test does not support parallel testing
  enableParallelBuilding = false;

  __structuredAttrs = true;

  nativeBuildInputs = [
    exiftool
    zoxide
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  preCheck = ''
    mkdir -p $HOME/.local/share/superfile

    # TestLayout expects at least one entry
    touch "$HOME/test-file"

    # TestFileDelete/Move_to_trash needs .Trash available
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$HOME/.Trash"
    ''}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pretty fancy and modern terminal file manager";
    homepage = "https://github.com/yorukot/superfile";
    changelog = "https://github.com/yorukot/superfile/blob/${finalAttrs.src.tag}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      redyf
    ];
    mainProgram = "superfile";
  };
})
