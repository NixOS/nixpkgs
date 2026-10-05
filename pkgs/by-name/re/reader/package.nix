{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "reader";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "reader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U9EXo3mAkeYVMOyEwIPWODqeg36lPj2ARNqW1yKayNI=";
  };

  vendorHash = "sha256-xs8zNXTYhbj6Ilhmf1IRyQUwV95Em7qwV/V3+IXRxFI=";

  meta = {
    description = "Lightweight tool offering better readability of web pages on the CLI";
    homepage = "https://github.com/mrusme/reader";
    changelog = "https://github.com/mrusme/reader/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "reader";
  };
})
