{
  lib,
  rustPlatform,
  fetchCrate,
  fetchurl,
  pkg-config,
  dbus,
  sops,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "secretspec";
  version = "0.17.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-3UW0j5i+2r8yWaYYCtbdtiPJe8epLKeR1cpP35Bxko4=";
  };

  cargoHash = "sha256-I6HFcWPB5TUSMtnk+SEHMxiKlPBxHLrj8zgzEWllV2w=";

  postPatch = ''
    mkdir -p schema
    cp ${
      fetchurl {
        url = "https://raw.githubusercontent.com/cachix/secretspec/v${finalAttrs.version}/schema/resolution-report.schema.json";
        hash = "sha256-MDuWWa05hh3g5AtaJnoe6qDvf1XVO3C29zKJDm+f+h0=";
      }
    } schema/resolution-report.schema.json
    substituteInPlace src/tests.rs \
      --replace-fail '../../schema/resolution-report.schema.json' '../schema/resolution-report.schema.json'
  '';

  nativeBuildInputs = [ pkg-config ];
  nativeCheckInputs = [ sops ];
  buildInputs = [ dbus ];

  preCheck = ''
    export HOME="$TMPDIR"
  '';

  # A test binds to localhost, which requires an explicit Darwin sandbox exception.
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      domenkozar
      sandydoo
    ];
    mainProgram = "secretspec";
  };
})
