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

  vendorHash = "sha256-ngYkTtBEZSyYYnfBHi0VrotwKGvMOiowbrwigJnjsuU=";

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
    # Build fails with Go >=1.21, couldn't be fixed by updating module dependencies.
    broken = true;
    description  = "Autonomous (self-hosted) BitTorrent DHT search engine suite";
    homepage     = "https://github.com/ireun/magnetico";
    license      = licenses.agpl3Only;
    badPlatforms = platforms.darwin;
    maintainers  = with maintainers; [ rnhmjoj ];
  };
}
