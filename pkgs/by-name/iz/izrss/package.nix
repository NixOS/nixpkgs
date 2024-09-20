{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
let
  version = "0.1.0";
in
buildGoModule {
  pname = "izrss";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "refs/tags/v${version}";
    hash = "sha256-Op9aiCQrBH8TuhMTt+3Wthd8UY3lU2g9yJ110v7TtXA=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-/TRCD6akZV2qDqJz62p7UzFIGuTAKLnUtYqqvdw3rCI=";

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
