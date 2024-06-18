{ lib
, fetchFromGitHub
, fetchpatch
, nixosTests
, buildGoModule
, sqlite
}:

buildGoModule {
  pname = "magnetico";
  version = "unstable-2022-08-10";

  src = fetchFromGitHub {
    owner  = "ireun";
    repo   = "magnetico";
    rev    = "828e230d3b3c0759d3274e27f5a7b70400f4d6ea";
    hash   = "sha256-V1pBzillWTk9iuHAhFztxYaq4uLL3U3HYvedGk6ffbk=";
  };

  patches = [
    # https://github.com/ireun/magnetico/pull/15
    (fetchpatch {
      url = "https://github.com/ireun/magnetico/commit/90db34991aa44af9b79ab4710c638607c6211c1c.patch";
      hash = "sha256-wC9lVQqfngQ5AaRgb4TtoWSgbQ2iSHeQ2UBDUyWjMK8=";
     })
  ];

  vendorHash = "sha256-JDrBXjnQAcWp8gKvnm+q1F5oV+FozKUvhHK/Me/Cyj8=";

  buildInputs = [ sqlite ];

  buildPhase = ''
    runHook preBuild

    make magneticow magneticod

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    make test

    runHook postCheck
  '';

  passthru.tests = { inherit (nixosTests) magnetico; };

  meta = with lib; {
    description  = "Autonomous (self-hosted) BitTorrent DHT search engine suite";
    homepage     = "https://github.com/ireun/magnetico";
    license      = licenses.agpl3Only;
    badPlatforms = platforms.darwin;
    maintainers  = with maintainers; [ rnhmjoj ];
  };
}
