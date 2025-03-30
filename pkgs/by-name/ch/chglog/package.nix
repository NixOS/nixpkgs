{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "chglog";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "chglog";
    tag = "v${version}";
    hash = "sha256-i7KJB5EWq1khP4oxxXGH2tYLJ9s6MAWd1Ndfk7LV0Vc=";
  };

  vendorHash = "sha256-EyA440J3QLQI+NvSZrksjIlmNOIOt1YO/5ZZMTV/GIs=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.builtBy=nixpkgs"
  ];

  meta = {
    description = "Changelog management library and tool";
    homepage = "https://github.com/goreleaser/chglog";
    changelog = "https://github.com/goreleaser/chglog/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ rewine ];
    mainProgram = "chglog";
  };
}
