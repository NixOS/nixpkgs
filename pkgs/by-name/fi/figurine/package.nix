{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "figurine";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "arsham";
    repo = "figurine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-U25nbXr8SuSgMq1Nqk/7Ci4tKoWAyccv8j4aTIEox3k=";
  };

  vendorHash = "sha256-CdiHPN0zfOedsz2M6JWFMQpG70vxLbKj//WkKyN58AQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.currentSha=${finalAttrs.src.rev}"
  ];

  meta = {
    homepage = "https://github.com/arsham/figurine";
    description = "Print your name in style";
    mainProgram = "figurine";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ironicbadger ];
  };
})
