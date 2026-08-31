{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "genemichaels";
  version = "0.12.4";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-0D2MkbqkrWkieZzfmGD2RtmoXMnmiCMeX9A/CMq1HYc=";
  };

  cargoHash = "sha256-dngajxpcn5azLwc8hyttCnr014J7xE1KnQCElKIosdU=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
})
