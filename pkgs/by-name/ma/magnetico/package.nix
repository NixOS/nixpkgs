{
  lib,
  stdenv,
  fetchFromGitea,
  buildGoModule,
  nixosTests,
  sqlite,
}:

buildGoModule rec {
  pname = "magnetico";
  version = "0.12.1";

  src = fetchFromGitea {
    domain = "maxwell.eurofusion.eu/git";
    owner = "rnhmjoj";
    repo = "magnetico";
    rev = "v${version}";
    hash = "sha256-cO5TVtQ1jdW1YkFtj35kmRfJG46/lXjXyz870NCPT0g=";
  };

  vendorHash = "sha256-jIVMQtPCq9RYaYsH4LSZJFspH6TpCbgzHN0GX8cM/CI=";

  buildInputs = [ sqlite ];

  tags = [
    "fts5"
    "libsqlite3"
  ];
  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = !stdenv.hostPlatform.isStatic;

  passthru.tests = { inherit (nixosTests) magnetico; };

  meta = with lib; {
    description = "Autonomous (self-hosted) BitTorrent DHT search engine suite";
    homepage = "https://maxwell.eurofusion.eu/git/rnhmjoj/magnetico";
    license = licenses.agpl3Only;
    badPlatforms = platforms.darwin;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
