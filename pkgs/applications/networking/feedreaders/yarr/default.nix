{ lib, buildGoModule, fetchFromGitHub, testers, yarr }:

buildGoModule rec {
  pname = "yarr";
<<<<<<< HEAD
  version = "2.4";
=======
  version = "2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nkanaev";
    repo = "yarr";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ZMQ+IX8dZuxyxQhD/eWAe4bGGCVcaCeVgF+Wqs79G+k=";
  };

  vendorHash = null;
=======
    hash = "sha256-LW0crWdxS6zcY5rxR0F2FLDYy9Ph2ZKyB/5VFVss+tA=";
  };

  vendorHash = "sha256-yXnoibqa0+lHhX3I687thGgasaVeNiHpGFmtEnH7oWY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
