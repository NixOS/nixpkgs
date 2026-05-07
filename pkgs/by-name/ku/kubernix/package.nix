{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kubernix";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "saschagrunert";
    repo = "kubernix";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-1cnh4h8rX6Uv/JlUy2uSpwgcjo2yTyTi+bHvWREZ7e0=";
  };

  cargoHash = "sha256-7Pyj+sLvkEOIYt7UYcpsS65gjNHxXZQS1RRQDagCW8Y=";

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Single dependency Kubernetes clusters for local testing, experimenting and development";
    mainProgram = "kubernix";
    homepage = "https://github.com/saschagrunert/kubernix";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ saschagrunert ];
    platforms = lib.platforms.linux;
  };
})
