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
  version = "0.13.0";

  src = fetchFromGitea {
    domain = "maxwell.eurofusion.eu/git";
    owner = "rnhmjoj";
    repo = "magnetico";
    rev = "v${version}";
    hash = "sha256-TqzsgUSPIBQT+k+ZrJPkF7uIt8o018ZN5p8nHom8cXM=";
  };

  vendorHash = "sha256-ZUtmQib6BD7P07ALYXKp/JAQodYnQCuvWZnWl9888Mg=";

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
