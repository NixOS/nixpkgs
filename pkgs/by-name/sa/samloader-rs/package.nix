{
  lib,
  rustPlatform,
  fetchFromGitHub,
  perl,
  cacert,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "samloader-rs";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "topjohnwu";
    repo = "samloader-rs";
    tag = finalAttrs.version;
    hash = "sha256-KexuDojik7AmWzGErKwVoWk97ex0MtXcMoFOpFjg81Q=";
  };

  cargoHash = "sha256-L3Ysb26pp2HXxIwj58TFBQtWp4K8gzi6C7HMrGjFyIE=";

  nativeBuildInputs = [ perl ];

  nativeCheckInputs = [ cacert ];

  checkFeatures = [ "mock" ];

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
