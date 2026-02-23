{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ducker";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "robertpsoane";
    repo = "ducker";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-/IFOMVCHoR+DxYkH4I2zml4wh8AEdWmdzl86+kTekFA=";
  };

  cargoHash = "sha256-jlxhf4CLw7ZxDXM6YvtIAvub0dAJlQm1LxAeAuhQE9g=";

  meta = {
    description = "Terminal app for managing docker containers, inspired by K9s";
    homepage = "https://github.com/robertpsoane/ducker";
    changelog = "https://github.com/robertpsoane/ducker/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ducker";
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ anas ];
  };
})
