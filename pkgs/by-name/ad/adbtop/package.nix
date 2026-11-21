{
  rustPlatform,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "adbtop";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "aabolfazl";
    repo = "adbtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rLFom59xf12EMmMpZGRAM2GH1jjiyKGL2FD3++OZUPw=";
  };

  cargoHash = "sha256-381NifKrTun4GOmrcBJbDk6bPTxN1eYmFbltgzo8Y7o=";

  passthru.updateScript = nix-update-script { };
  __structuredAttrs = true;

  meta = {
    description = "Live performance for Android apps, in your terminal and your CI";
    homepage = "https://github.com/aabolfazl/adbtop";
    changelog = "https://github.com/aabolfazl/adbtop/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.johnhamelink ];
    mainProgram = "adbtop";
  };
})
