{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "managarr";
  version = "0.7.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Dark-Alex-17";
    repo = "managarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NdKtyvWNFBhXb6bxclfa/68/5WqOhlqLnEd0e2LQ10Q=";
  };

  cargoHash = "sha256-yecVTD/UC0vNuCRpLBr7GxT3Bs+Zs5oZHNcBa2HQns4=";

  nativeBuildInputs = [ perl ];

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "TUI and CLI to manage your Servarrs";
    homepage = "https://github.com/Dark-Alex-17/managarr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      IncredibleLaser
      darkalex
      nindouja
      kybe236
    ];
    mainProgram = "managarr";
  };
})
