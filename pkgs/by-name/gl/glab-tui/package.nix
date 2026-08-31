{
  fetchFromGitHub,
  gh,
  glab,
  lib,
  makeWrapper,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "glab-tui";
  version = "0.9.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rcieri";
    repo = "glab-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3Zke2A9OcnZxaFBE/u6GJ73TTAVWV8TakIwnRo6V4+Q=";
  };

  cargoHash = "sha256-8L8SD0wgaLATcWngzuUD67Nd5+7vt6fTTZk/2BDnkJw=";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/glab-tui \
      --prefix PATH : ${
        lib.makeBinPath [
          glab
          gh
        ]
      }
  '';

  checkFlags = [
    /*
      These tests (https://github.com/rcieri/glab-tui/blob/main/tests/e2e/pagination.rs) are a bit flaky and non critical :
      1. They relly on a mock glab and gh, which for some reason does not work well with nix sandbox, building process and environment.
      2. They address pagination issue (ex: Is there the correct number of issues shown on each glab-tui page?). It is unlikely that pagination will fail only on nixos build and not in CI and other distribution packages.
      3. In the case they do fail, it's not a big deal that glab-tui shows 101 or 99 issues on the first page instead of 100.
    */
    "--skip=pagination::test_pagination_custom_per_endpoint"
    "--skip=pagination::test_pagination_empty_response"
    "--skip=pagination::test_pagination_fallback_invalid"
    "--skip=pagination::test_pagination_large_limit"
    "--skip=pagination::test_pagination_max_bounds"
    "--skip=pagination::test_pagination_negative"
    "--skip=pagination::test_pagination_normal_limit"
    "--skip=pagination::test_pagination_single_item"
    "--skip=pagination::test_pagination_small_limit"
    "--skip=pagination::test_pagination_zero"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal user interface for GitLab/GitHub.";
    homepage = "https://github.com/rcieri/glab-tui";
    changelog = "https://github.com/rcieri/glab-tui/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "glab-tui";
    maintainers = with lib.maintainers; [ tomasrivera ];
  };
})
