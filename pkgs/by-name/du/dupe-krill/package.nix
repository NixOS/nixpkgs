{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dupe-krill";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = "dupe-krill";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Udj5Uc1P/c/wiF42m/qPrTtSvMpNsXjqP0LR08zslNI=";
  };

  cargoHash = "sha256-iNkuhohlqjbcn/R6tCkI5rvSbyZw4Ynac27Lb8tycp8=";

  meta = {
    description = "Fast file deduplicator";
    homepage = "https://github.com/kornelski/dupe-krill";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ urbas ];
    mainProgram = "dupe-krill";
  };
})
