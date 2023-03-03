{ lib
, fetchFromGitHub
, nixosTests
, buildGoModule
}:

buildGoModule rec {
  pname = "magnetico";
  version = "unstable-2022-08-10";

  src = fetchFromGitHub {
    owner  = "ireun";
    repo   = "magnetico";
    rev    = "828e230d3b3c0759d3274e27f5a7b70400f4d6ea";
    sha256 = "sha256-V1pBzillWTk9iuHAhFztxYaq4uLL3U3HYvedGk6ffbk=";
  };

  vendorSha256 = "sha256-ngYkTtBEZSyYYnfBHi0VrotwKGvMOiowbrwigJnjsuU=";

  buildPhase = ''
    runHook preBuild

    make magneticow magneticod

    runHook postBuild
  '';

  checkPhase = ''
    runHook preBuild

    make test

    runHook postBuild
  '';

  passthru.tests = { inherit (nixosTests) magnetico; };

  meta = with lib; {
    description  = "Autonomous (self-hosted) BitTorrent DHT search engine suite";
    homepage     = "https://github.com/boramalper/magnetico";
    license      = licenses.agpl3;
    badPlatforms = platforms.darwin;
    maintainers  = with maintainers; [ rnhmjoj ];
  };
}
