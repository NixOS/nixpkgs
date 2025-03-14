{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "hatsu";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "importantimport";
    repo = "hatsu";
    tag = "v${version}";
    hash = "sha256-lIuaG7xfBQ1r3SkgSsXj1Ph9apxwP3oI42uunMh+ijU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gja8bVsnumJ0R3sN1WBV6WXAWjO9v/K+uBpNO1cTgRs=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Self-hosted and fully-automated ActivityPub bridge for static sites";
    homepage = "https://github.com/importantimport/hatsu";
    changelog = "https://github.com/importantimport/hatsu/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "hatsu";
    maintainers = with lib.maintainers; [ kwaa ];
    platforms = lib.platforms.linux;
  };
}
