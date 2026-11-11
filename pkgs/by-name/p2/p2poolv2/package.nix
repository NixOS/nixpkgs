{
  lib,
  fetchFromGitHub,
  rustPlatform,

  pkg-config,
  openssl,
  cacert,
  aws-lc,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "p2poolv2";
  version = "0.18.0";
  useNextest = true;

  src = fetchFromGitHub {
    owner = "p2poolv2";
    repo = "p2poolv2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DvSPlAhXKrBznITYGU4AsJDA7CbDQXyo++SwTh4Vw1c=";
  };

  cargoHash = "sha256-+Zg2bI57i2/98+lhfYWiT+fmJ7eM7j+idat9GVwRiUA=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    openssl
    cacert
  ];

  buildInputs = [
    aws-lc
    zstd
  ];

  postInstall = ''
    # copy static api files
    cp -r p2poolv2_api/static $out/
  '';

  meta = {
    description = "Peer-to-peer Bitcoin mining pool where miners coordinate directly and verify their rewards without centralized operators";
    license = with lib.licenses; [
      asl20
      mit
    ];

    maintainers = with lib.maintainers; [
      adevries17
      msgilligan
    ];
    mainProgram = "p2poolv2";
  };
})
