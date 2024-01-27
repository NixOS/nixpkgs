{ lib
, fetchFromGitHub
, buildGoModule
, testers
, athens
}:
buildGoModule rec {
  pname = "athens";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "gomods";
    repo = "athens";
    rev = "v${version}";
    hash = "sha256-tyheAQ+j1mkkkJr0yTyzWwoEFMcTfkJN+qFbb6Zcs+s=";
  };

  vendorHash = "sha256-8+PdkanodNZW/xeFf+tDm3Ej7DRSpBBtiT/CqjnWthw=";

  CGO_ENABLED = "0";
  ldflags = [ "-s" "-w" "-X github.com/gomods/athens/pkg/build.version=${version}" ];

  subPackages = [ "cmd/proxy" ];

  postInstall = ''
    mv $out/bin/proxy $out/bin/athens
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = athens;
    };
  };

  meta = with lib; {
    description = "A Go module datastore and proxy";
    homepage = "https://github.com/gomods/athens";
    changelog = "https://github.com/gomods/athens/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "athens";
    maintainers = with maintainers; [ katexochen malt3 ];
    platforms = platforms.unix;
  };
}
