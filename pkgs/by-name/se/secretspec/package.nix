{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  dbus,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "secretspec";
  version = "0.7.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-2rg6A0TitVf5Q9+DdtDNt0YaUyVSCzAuAJX87RTCbpU=";
  };

  cargoHash = "sha256-uOx1vXrQUmjtBM3fg56wBhrOZCYbrex8gHAvhXTkDzw=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [
      domenkozar
      sandydoo
    ];
    mainProgram = "secretspec";
  };
})
