{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "atlas-bin";
  version = "1.3.2";

  strictDeps = true;
  __structuredAttrs = true;

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  dontUnpack = true;
  dontStrip = true;

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/atlas"
    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd atlas \
      --bash <($out/bin/atlas completion bash) \
      --fish <($out/bin/atlas completion fish) \
      --zsh <($out/bin/atlas completion zsh)
  '';

  passthru = {
    sources = {
      x86_64-linux = fetchurl {
        url = "https://atlasbinaries.com/atlas/atlas-linux-amd64-v${finalAttrs.version}";
        hash = "sha256-l1XVRIbffuyL4zet7HZE3yxXJldWYIyfCz6al5Sjx3Q=";
      };
      aarch64-linux = fetchurl {
        url = "https://atlasbinaries.com/atlas/atlas-linux-arm64-v${finalAttrs.version}";
        hash = "sha256-qco6375ivYYai5cmuhAFAGqNo5Y5HCF0Eh1LasdrZJA=";
      };
      x86_64-darwin = fetchurl {
        url = "https://atlasbinaries.com/atlas/atlas-darwin-amd64-v${finalAttrs.version}";
        hash = "sha256-Kvc3uc4uur8MOg4fFTvqedsOHDjlioXphbVZZm/u1mA=";
      };
      aarch64-darwin = fetchurl {
        url = "https://atlasbinaries.com/atlas/atlas-darwin-arm64-v${finalAttrs.version}";
        hash = "sha256-gVN1eBXTF4EFW7uX3R6lypgfReqPVfvJg9D0KXI+rlc=";
      };
    };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "atlas version";
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "Manage your database schema as code (official binary distribution)";
    homepage = "https://atlasgo.io/";
    changelog = "https://atlasgo.io/changelog";
    license = {
      fullName = "Atlas Master Subscription Agreement";
      url = "https://ariga.io/legal/msa";
      free = false;
    };
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ nemith ];
    mainProgram = "atlas";
    platforms = builtins.attrNames finalAttrs.passthru.sources;
  };
})
