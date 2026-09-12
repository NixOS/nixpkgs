{
  lib,
  fetchFromGitHub,
  buildGoModule,
  exiftool,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "f2";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "ayoisaiah";
    repo = "f2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+rHqNTJ8L9tanoQhDCjK2Niv4ZPwIlt348AdYyHZ798=";
  };

  vendorHash = "sha256-tH75OI9fTMEKqoTrWgl0d0Jv/M8NNCM7iJOS73we/hI=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ayoisaiah/f2/v2/app.VersionString=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ exiftool ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line batch renaming tool";
    homepage = "https://github.com/ayoisaiah/f2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      prince213
      zendo
    ];
    mainProgram = "f2";
  };
})
