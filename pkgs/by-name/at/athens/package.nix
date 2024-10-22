{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  athens,
}:

buildGoModule rec {
  pname = "athens";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "gomods";
    repo = "athens";
    rev = "v${version}";
    hash = "sha256-Ikm9nznJhd5ZrkJyh3ny1SZeuWVs5xgT4fpWKhVbuDA=";
  };

  vendorHash = "sha256-cK23BIGh/BK1OHHrI++PD1h7lCN7NZfV1Yfirs8vC5A=";

  CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-X github.com/gomods/athens/pkg/build.version=${version}"
  ];

  subPackages = [ "cmd/proxy" ];

  postInstall = ''
    mv $out/bin/proxy $out/bin/athens
  '';

  passthru = {
    tests.version = testers.testVersion { package = athens; };
  };

  meta = with lib; {
    description = "Go module datastore and proxy";
    homepage = "https://github.com/gomods/athens";
    changelog = "https://github.com/gomods/athens/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "athens";
    maintainers = with maintainers; [
      katexochen
      malt3
    ];
    platforms = platforms.unix;
  };
}
