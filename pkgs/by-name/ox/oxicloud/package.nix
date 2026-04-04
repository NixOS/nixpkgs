{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxicloud";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "DioCrafts";
    repo = "OxiCloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5OvqXjSTqJuwVSRhL/XcB0v6FLdLldOIclfMHd3OuEs=";
  };

  cargoHash = "sha256-ImM7jDquzuSdVRTG+JHZb7bTjjob4GGoLA1wRJCjA9c=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast and lightweight self-hosted cloud storage alternative to Nextcloud";
    homepage = "https://github.com/DioCrafts/OxiCloud";
    changelog = "https://github.com/DioCrafts/OxiCloud/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "oxicloud";
    platforms = lib.platforms.linux;
  };
})
