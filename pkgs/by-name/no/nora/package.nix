{
  cacert,
  fetchFromGitHub,
  fetchurl,
  lib,
  gnused,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nora";
  version = "1.3.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "getnora-io";
    repo = "nora";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KYK3y9Nf+DGqjc7UCabwwzjfwo5WXVf625aL30j9U+o=";
  };
  cargoHash = "sha256-q4Y4IOLM+NCo232AeMmR93zMeEKgxoePfrup/dA6giA=";

  postPatch = ''
    ${gnused}/bin/sed -i '/"fuzz"/d' Cargo.toml
  '';

  preCheck = ''
    rm -rf target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/build/
  '';

  cargoBuildFlags = [
    "-p"
    "nora-registry"
  ];

  env.SWAGGER_UI_DOWNLOAD_URL =
    let
      swaggerUi = fetchurl {
        url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.14.zip";
        hash = "sha256-SBJE0IEgl7Efuu73n3HZQrFxYX+cn5UU5jrL4T5xzNw=";
      };
    in
    "file://${swaggerUi}";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doCheck = true;
  doInstallCheck = true;

  meta = {
    description = "NORA Artifact Registry";
    longDescription = "Lightweight multi-format artifact registry supporting Docker, Maven, npm, and more.";
    homepage = "https://github.com/getnora-io/nora";
    changelog = "https://github.com/getnora-io/nora/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "nora";
    maintainers = with lib.maintainers; [
      cazier
    ];
  };
})
