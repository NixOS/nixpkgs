{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "repak";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "trumank";
    repo = "repak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fvB8Loukfy35+hqt3fhAubHhSCAd1TFE6TuBZ0xUkxE=";
  };

  cargoHash = "sha256-1jpjVQ+EiDUnGaTwDHMpLwLA/CkVGdZ+iLiWEkEpAwg=";

  checkFlags = [
    "--skip=test::test_oodle"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unreal Engine .pak file library and CLI in rust";
    homepage = "https://github.com/trumank/repak";
    changelog = "https://github.com/trumank/repak/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ florensie ];
    mainProgram = "repak";
  };
})
