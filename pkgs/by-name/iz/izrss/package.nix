{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "izrss";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cBkq+Xq6FxizftYZ1YelYdubWNakLbkhGE55hkOr4Qo=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-hiqheaGCtybrK5DZYz2GsYvTlUZDGu04wDjQqfE7O3k=";

  meta = {
    description = "RSS feed reader for the terminal written in Go";
    changelog = "https://github.com/isabelroses/izrss/releases/v${finalAttrs.version}";
    homepage = "https://github.com/isabelroses/izrss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      isabelroses
      luftmensch-luftmensch
    ];
    mainProgram = "izrss";
  };
})
