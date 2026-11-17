{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  gitMinimal,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rhuffle";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ctylim";
    repo = "rhuffle";
    tag = finalAttrs.version;
    hash = "sha256-daA5MzSCtBe8NK5tvCv6GjrkjdQtHMUsDyuC2Jisb9Y=";
  };

  cargoHash = "sha256-SMGT/vfU6rVluRQm1ztFP3OJz853XQZhn+eB3TbniKo=";

  nativeBuildInputs = [
    gitMinimal
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Line shuffler for huge text file which does not fit in memory";
    homepage = "https://github.com/ctylim/rhuffle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "rhuffle";
  };
})
