{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lix-diff";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "lix-diff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uZd8xoQWsvJCmHtxtKJzKtaupUdXMXKWqSjXnK/BZco=";
  };

  cargoHash = "sha256-ydB65V879tW42FXSgdoUDeQbovsVf8qXku9uW4mqAfs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/isabelroses/lix-diff";
    description = "Lix plugin for diffing two generations";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "lix-diff";
  };
})
