{ lib, buildGoModule, fetchFromGitHub, testers, yarr }:

buildGoModule rec {
  pname = "yarr";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "nkanaev";
    repo = "yarr";
    rev = "v${version}";
    hash = "sha256-LW0crWdxS6zcY5rxR0F2FLDYy9Ph2ZKyB/5VFVss+tA=";
  };

  vendorHash = "sha256-yXnoibqa0+lHhX3I687thGgasaVeNiHpGFmtEnH7oWY=";

  subPackages = [ "src" ];

  ldflags = [ "-s" "-w" "-X main.Version=${version}" "-X main.GitHash=none" ];

  tags = [ "sqlite_foreign_keys" "release" ];

  postInstall = ''
    mv $out/bin/{src,yarr}
  '';

  passthru.tests.version = testers.testVersion {
    package = yarr;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Yet another rss reader";
    homepage = "https://github.com/nkanaev/yarr";
    changelog = "https://github.com/nkanaev/yarr/blob/v${version}/doc/changelog.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
