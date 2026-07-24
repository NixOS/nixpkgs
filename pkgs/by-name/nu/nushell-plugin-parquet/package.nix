{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_parquet";
  version = "0.22";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-TFzYa4jMy664rW+FRKYAcKo+niJg0IcEEyinGrpXbBg=";
  };

  cargoHash = "sha256-hiiddu/0vjeLTh9G0MpNCLPJ8gq7JvEAw9SLPSrCUVA=";

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  # there are no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin to read and write parquet files";
    mainProgram = "nu_plugin_parquet";
    homepage = "https://github.com/fdncred/nu_plugin_parquet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ asakura ];
  };
})
