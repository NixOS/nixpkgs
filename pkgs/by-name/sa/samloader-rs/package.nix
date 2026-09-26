{
  lib,
  rustPlatform,
  fetchFromGitHub,
  perl,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "samloader-rs";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "topjohnwu";
    repo = "samloader-rs";
    tag = finalAttrs.version;
    hash = "sha256-vUoRO//RSPv0Z69nyeiwtFIN+5lkOjguR96KjsLpc5U=";
  };

  cargoHash = "sha256-rqJ0/h/HDBlXQ7MGQspKXMSUEGaddkxRqdQmwSlfttc=";

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
