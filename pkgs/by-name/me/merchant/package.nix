{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "merchant";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "samgqroberts";
    repo = "merchant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OlpOFjRQ1ifi8/dwuTbtRbjzI3v6egEuW3iB2zQN9LU=";
  };

  cargoHash = "sha256-J55RDe92XsR1gJf0cM6EmL4BfMotyHwesP7UMac7uM0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clone of the classic terminal UI game Drug Wars";
    longDescription = ''
      A clone of the classic terminal UI game Drug Wars, but now set
      on a merchant ship in the 18th century.
    '';
    homepage = "https://github.com/samgqroberts/merchant";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "merchant";
  };
})
