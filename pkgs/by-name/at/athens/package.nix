{ lib
, fetchFromGitHub
, buildGoModule
, testers
, athens
}:
buildGoModule rec {
  pname = "athens";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "gomods";
    repo = "athens";
    rev = "v${version}";
    hash = "sha256-27BBPDK5lGwEFsgLf+/lE9CM8g1AbGUgM1iOL7XZqsU=";
  };

  vendorHash = "sha256-5U9ql0wszhr5H3hAo2utONuEh4mUSiO71XQHkAnMhZU=";

  CGO_ENABLED = "0";
  ldflags = [ "-s" "-w" "-buildid=" "-X github.com/gomods/athens/pkg/build.version=${version}" ];

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
