{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lix-diff";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "tgirlcloud";
    repo = "lix-diff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aLmCS+Q6B/DU6DZ0U/FfCOovwZTSTAG5vrCGHZ1Xsrk=";
  };

  cargoHash = "sha256-g50St9tX2IYaPmnjSE8AeSKqUF5Ou87Y5F0zVBK3Xxo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/isabelroses/lix-diff";
    description = "Lix plugin for diffing two generations";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "lix-diff";
  };
})
