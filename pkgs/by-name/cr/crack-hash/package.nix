{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "crack-hash";
  version = "1.1.0-unstable-2025-12-31";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kOaDT";
    repo = "crack-hash";
    # https://github.com/kOaDT/crack-hash/issues/2
    rev = "887bedec144b59488b93dbe33a6f781f83360ea7";
    hash = "sha256-h2NEuyEX5JEpSmtT7Pn/TJkKeMx+dupLQo4iLHcw3AY=";
  };

  cargoHash = "sha256-mD/3pWY8jf8QCgtYYtPxyVD6SheYi76tNhoJ4uyJ0WU=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hash cracking tool";
    homepage = "https://github.com/kOaDT/crack-hash";
    # https://github.com/kOaDT/crack-hash/issues/1
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "crack-hash";
  };
})
