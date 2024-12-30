{
  lib,
  testers,
  shopify-cli,
  fetchFromGitHub,
  stdenv,
  pnpm,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "shopify";
  version = "3.72.2";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "cli";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-iAnOuGi7n3qd0rfQ9aPXWIkBiafmjL0ELDiigGn/DmE=";
  };

  nativeBuildInputs = [
    #nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-PWFyyP4qcp7RIcmAdFRnvRo8KppeEvSmFgtcBMm2xlg=";
  };

  passthru = {
    tests.version = testers.testVersion {
      package = shopify-cli;
      command = "shopify version";
    };
  };

  meta = {
    platforms = lib.platforms.all;
    mainProgram = "shopify";
    description = "CLI which helps you build against the Shopify platform faster";
    homepage = "https://github.com/Shopify/cli";
    changelog = "https://github.com/Shopify/cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fd
      onny
    ];
  };
})
