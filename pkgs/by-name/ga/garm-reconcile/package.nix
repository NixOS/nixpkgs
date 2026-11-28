{
  lib,
  buildGoModule,
  fetchFromGitHub,
  garm,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "garm-reconcile";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "katexochen";
    repo = "garm-reconcile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l9qrfIZvLsNENJNAAYy7iUcdHtwsGDNyPAqL2qzg/Ng=";
  };

  vendorHash = "sha256-BSVasuE8ugpdKkNoLoQ+f0dtTBon0IKtRIp9Ua0Geto=";

  ldflags = [ "-s" ];

  nativeCheckInputs = [ garm ];

  passthru = {
    tests = {
      inherit (nixosTests) garm-incus;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Declarative configuration for GARM";
    homepage = "https://github.com/katexochen/garm-reconcile";
    changelog = "https://github.com/katexochen/garm-reconcile/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "garm-reconcile";
    platforms = lib.platforms.linux;
  };
})
