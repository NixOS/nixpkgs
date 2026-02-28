{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "newdoc";
  version = "2.18.6";

  src = fetchFromGitHub {
    owner = "redhat-documentation";
    repo = "newdoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fd5B6xC/wKiaepHy5GsHeyqzghcnNCOT7GySfIEW8IM=";
  };

  cargoHash = "sha256-6VIC+OZifbIRWKtbG+MFLxhK8C2PM1pFr3MjF2hf6vs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate pre-populated module files formatted with AsciiDoc";
    homepage = "https://redhat-documentation.github.io/newdoc/";
    downloadPage = "https://github.com/redhat-documentation/newdoc";
    changelog = "https://github.com/redhat-documentation/newdoc/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "newdoc";
  };
})
