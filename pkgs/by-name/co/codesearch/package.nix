{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "codesearch";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "codesearch";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-i03w8PZ31j5EutUZaamZsHz+z4qgX4prePbj5DLA78s=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Fast, indexed regexp search over large file trees";
    homepage = "https://github.com/google/codesearch";
    license = [ lib.licenses.bsd3 ];
    maintainers = with lib.maintainers; [ bennofs ];
  };
})
