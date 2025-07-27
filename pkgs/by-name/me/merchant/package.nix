{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "merchant";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "samgqroberts";
    repo = "merchant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JY8+rwY533oanFgDKFaTByX9MkZwSV9Mkwc2LMjUv7k=";
  };

  cargoHash = "sha256-2GUFwuTmNsHwuGwnL7+b6DzlXDEtNht07rD7kAd3vaQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clone of the classic terminal UI game Drug Wars";
    longDescription = ''
      A clone of the classic terminal UI game Drug Wars, but now set
      on a merchant ship in the 18th century.
    '';
    homepage = "https://github.com/samgqroberts/merchant";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "merchant";
  };
})
