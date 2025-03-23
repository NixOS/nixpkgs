{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
let
  version = "0.2.0";
in
buildGoModule {
  pname = "izrss";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    tag = "v${version}";
    hash = "sha256-t+RtdKrYI0MNGSR1ABvClKv+hUJ4Tpg7yKS2qbm7BKc=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-2L/EUoPbz6AZqv84XPhiZhImOL4wyBOzx6Od4+nTJeY=";

  meta = {
    description = "RSS feed reader for the terminal written in Go";
    changelog = "https://github.com/isabelroses/izrss/releases/v${version}";
    homepage = "https://github.com/isabelroses/izrss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      isabelroses
      luftmensch-luftmensch
    ];
    mainProgram = "izrss";
  };
}
