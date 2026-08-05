{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "sshamble";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "runZeroInc";
    repo = "sshamble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ptZePWmFIqBftD+QVy9zPatRThxEOCZwk59eVNDFMn0=";
  };

  vendorHash = "sha256-plPV8JZHq2i4Lp1BI5vakOxr9VQJc8MIq8gm3hVTndw=";

  # Disabled because tests rely on network requests
  disabledTests = [
    "TestCacheBasics"
  ];
  checkFlags = [
    "-skip=${lib.concatStringsSep "|" finalAttrs.disabledTests}"
  ];

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "SSH-protocol pentesting utility";
    homepage = "https://github.com/runZeroInc/sshamble";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.YoshiRulz ];
    mainProgram = "sshamble";
  };
})
