{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  zstd,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "repak";
  version = "0.2.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "trumank";
    repo = "repak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fvB8Loukfy35+hqt3fhAubHhSCAd1TFE6TuBZ0xUkxE=";
  };

  cargoHash = "sha256-1jpjVQ+EiDUnGaTwDHMpLwLA/CkVGdZ+iLiWEkEpAwg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  checkFlags = [
    "--skip=test::test_oodle"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unreal Engine .pak file library and CLI in rust";
    homepage = "https://github.com/trumank/repak";
    changelog = "https://github.com/trumank/repak/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ florensie ];
    mainProgram = "repak";
  };
})
