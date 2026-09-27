{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "redli";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "IBM-Cloud";
    repo = "redli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kter7gMjCkhCTPGpCNsBhXh7NDOV2P2LeonCKkKTO80=";
  };

  vendorHash = "sha256-DI6WB7jCjoIPaze5HHKDjTddPeQkEXOA4gIOHOqbDqg=";

  meta = {
    description = "Humane alternative to the Redis-cli and TLS";
    homepage = "https://github.com/IBM-Cloud/redli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tchekda ];
    mainProgram = "redli";
  };
})
