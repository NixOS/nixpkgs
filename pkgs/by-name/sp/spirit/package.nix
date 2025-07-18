{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "spirit";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "cashapp";
    repo = "spirit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bGKqiCd9dggppORouoWlAoAaYdx4vAivsP22KWm1fxU=";
  };

  vendorHash = "sha256-87WUqUjyfprpY63kEKCAx/AU6TN73W7oMdOaKfl8xt4=";

  subPackages = [ "cmd/spirit" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://github.com/cashapp/spirit";
    description = "Online schema change tool for MySQL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "spirit";
  };
})
