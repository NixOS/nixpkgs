{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  athens,
}:

buildGoModule rec {
  pname = "athens";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "gomods";
    repo = "athens";
    rev = "v${version}";
    hash = "sha256-JERyECQ3/pI+ApWyWvUwZqkGBmA+6pP7Uj+RfpUGsOw=";
  };

  vendorHash = "sha256-tCpwiqJHGRo9vqUh00k+tg4X6WNPnnknV7zjPkgs6Zs=";

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
