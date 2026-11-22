{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "desed";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "SoptikHa2";
    repo = "desed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KPXXuRE8bC5DtMkHQSUPo/JKiRw8tSd938d7jUzHlh0=";
  };

  cargoHash = "sha256-baHR7XOa0pKlVobmFnkwE5/oHollQUh/5iTK9+6XRbI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/SoptikHa2/desed/releases/tag/v${finalAttrs.version}";
    description = "Debugger for Sed: demystify and debug your sed scripts, from comfort of your terminal";
    homepage = "https://github.com/SoptikHa2/desed";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ vinylen ];
    mainProgram = "desed";
  };
})
