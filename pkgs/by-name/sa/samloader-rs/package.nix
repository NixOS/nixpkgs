{
  lib,
  rustPlatform,
  fetchFromGitHub,
  perl,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "samloader-rs";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "topjohnwu";
    repo = "samloader-rs";
    tag = finalAttrs.version;
    hash = "sha256-0EsSs7GI4D4N3w33NBHKIEDmGk29aRceOwzDA7cy924=";
  };

  cargoHash = "sha256-3i2232Rq9AEqPK8teVmu5kPX10ZopXTm7djUalfPFng=";

  nativeBuildInputs = [ perl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Download firmware for Samsung devices";
    homepage = "https://github.com/topjohnwu/samloader-rs";
    changelog = "https://github.com/topjohnwu/samloader-rs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "samloader";
  };
})
