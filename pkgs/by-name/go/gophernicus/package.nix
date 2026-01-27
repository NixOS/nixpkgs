{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gophernicus";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "gophernicus";
    repo = "gophernicus";
    tag = finalAttrs.version;
    hash = "sha256-pweiUiMmLXiyF9NMxvcWfJPH6JiGRlpT4chJiRGh9vg=";
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, full-featured (and hopefully) secure gopher daemon";
    homepage = "https://github.com/gophernicus/gophernicus";
    changelog = "https://github.com/gophernicus/gophernicus/blob/${finalAttrs.src.tag}/changelog";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gophernicus";
    platforms = lib.platforms.all;
  };
})
