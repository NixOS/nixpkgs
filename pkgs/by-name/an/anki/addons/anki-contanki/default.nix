{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:

anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "anki-contanki";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "roxgib";
    repo = "anki-contanki";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a8EbCQVuxJv04RVtiGUz5ypRdqFUIqK8Uqz5Zf0XkqI=";
  };
  patches = [ ./config.patch ];
  patchFlags = [
    "-p1"
    "-d"
    ".."
  ];
  sourceRoot = "${finalAttrs.src.name}/contanki";
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "An add-on for Anki which allows users to control Anki using a gamepad or other controller device.";
    homepage = "https://github.com/roxgib/anki-contanki";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ hey2022 ];
  };
})
