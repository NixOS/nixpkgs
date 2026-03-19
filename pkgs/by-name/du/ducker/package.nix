{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ducker";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "robertpsoane";
    repo = "ducker";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-3o6uA3g1v4PiRYl6J4sOAllgwkEou7kS9E8us4DIZb0=";
  };

  cargoHash = "sha256-GUbRNXphkbm0oSjC8wKJgIhigtB4dbUwNuMSvCJUyaA=";

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
