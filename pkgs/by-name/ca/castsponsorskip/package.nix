{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "castsponsorskip";
  version = "0.8.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gabe565";
    repo = "CastSponsorSkip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qPn753aSKlMdSEEN1QYuS3hDYtjL4Pm07mEKY1kI5Ak=";
  };

  vendorHash = "sha256-ph6rwr4FxuNpFF5DedsrMEnm28xR11bC7EcaNQJcyug=";

  checkFlags =
    let
      skippedTests = [
        "Test_completeCategories" # Requires network access
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "Skip YouTube sponsorships (and sometimes ads) on all local Google Cast devices";
    homepage = "https://github.com/gabe565/CastSponsorSkip";
    changelog = "https://github.com/gabe565/CastSponsorSkip/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      wariuccio
    ];
  };
})
