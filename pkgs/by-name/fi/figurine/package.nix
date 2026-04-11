{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "figurine";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "arsham";
    repo = "figurine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1q6Y7oEntd823nWosMcKXi6c3iWsBTxPnSH4tR6+XYs=";
  };

  vendorHash = "sha256-mLdAaYkQH2RHcZft27rDW1AoFCWKiUZhh2F0DpqZELw=";

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
