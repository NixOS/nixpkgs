{
  lib,
  rustPlatform,
  python3,
  perl,
  openssl,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "s3rs";
  version = "0.4.19";

  src = fetchFromGitHub {
    owner = "yanganto";
    repo = "s3rs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mJ1bMfv/HY74TknpRvu8RIs1d2VlNreEVtHCtQSHQw8=";
  };

  cargoHash = "sha256-z7de/TZXyNsb+dxWcNFdJsaGsM3Ld2A0jorNMAVOZOg=";

  nativeBuildInputs = [
    python3
    perl
    pkg-config
  ];
  buildInputs = [ openssl ];

  meta = {
    description = "S3 cli client with multi configs with diffent provider";
    homepage = "https://github.com/yanganto/s3rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yanganto ];
    mainProgram = "s3rs";
  };
})
