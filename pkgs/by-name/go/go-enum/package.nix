{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-enum";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1eAMCr7GeXwzHS1E9Udp0l2eMOiihhm7aAOQEyKNQa8=";
  };

  vendorHash = "sha256-AlJzwJtQaJNqulw9alltwSw8gVEBx58cejlkgXYuOAI=";

  meta = {
    description = "Eum generator for go";
    homepage = "https://github.com/abice/go-enum";
    changelog = "https://github.com/abice/go-enum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmajid2301 ];
    mainProgram = "go-enum";
  };
})
