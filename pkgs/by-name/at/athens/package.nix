{ lib
, fetchFromGitHub
, buildGoModule
, testers
, athens
}:
buildGoModule rec {
  pname = "athens";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "gomods";
    repo = "athens";
    rev = "v${version}";
    hash = "sha256-vpg5EcQSxVFjDFKa4oHwF5fNHhLWtj3ZMi2wbMZNn/8=";
  };

  vendorHash = "sha256-LajNPzGbWqW+9aqiquk2LvSUjKwi1gbDY4cKXmn3PWk=";

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
    description = "Go module datastore and proxy";
    homepage = "https://github.com/gomods/athens";
    changelog = "https://github.com/gomods/athens/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "athens";
    maintainers = with maintainers; [ katexochen malt3 ];
    platforms = platforms.unix;
  };
}
