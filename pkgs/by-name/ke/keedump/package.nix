{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "keedump";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ynuwenhof";
    repo = "keedump";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V7wQZoUnISELuzjSUz+CJ77XJvlnGBK2n4U4pKlk+xI=";
  };

  cargoHash = "sha256-ogfLMkTzGwYADDfn05IOXiOSJzk5iN2GJ6kaT9L9sqM=";

  meta = {
    description = "PoC KeePass master password dumper";
    homepage = "https://github.com/ynuwenhof/keedump";
    changelog = "https://github.com/ynuwenhof/keedump/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "keedump";
  };
})
