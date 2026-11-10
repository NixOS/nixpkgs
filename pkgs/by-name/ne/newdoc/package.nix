{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "newdoc";
  version = "2.18.7";

  src = fetchFromGitHub {
    owner = "redhat-documentation";
    repo = "newdoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hAqmBH/Di9Zo5mB1lFp/wPAyRndoHWQRdRSWal1QFF8=";
  };

  cargoHash = "sha256-S8rjpRsL50f3YqLTwIpch0/sBQZhIlFnMu25tIZFXtU=";

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
