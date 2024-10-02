{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule {
  pname = "omnom";
  version = "0-unstable-2024-08-29";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "omnom";
    rev = "1fcd7787886503f703bbcd31b193d4c93acc5610";
    hash = "sha256-o/n8rgngQkYEn8J0aFpCiD4qrWVFaaa305OxiscU6+8=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-dsS5w8JXIwkneWScOFzLSDiXq+clgK+RdYiMw0+FnvY=";

  patches = [ ./0001-fix-minimal-go-version.patch ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
  ];

  postPatch = ''
    # For the default config to work, we have to put `static/data` and
    # `db.sqlite3` in a temporary directory since they need to be writeable.
    #
    # NOTE: Currently, `static/data` only holds the snapshots directory.
    substituteInPlace config.yml \
      --replace-fail 'root: "./static/data"' 'root: "/tmp/omnom/static/data"' \
      --replace-fail 'connection: "./db.sqlite3"' 'connection: "/tmp/omnom/db.sqlite3"' \
      --replace-fail 'debug: true' 'debug: false'
  '';

  postInstall = ''
    mkdir -p $out/share
    cp -r config.yml static templates $out/share

    wrapProgram $out/bin/omnom \
      --chdir $out/share \
      --set-default GIN_MODE release
  '';

  meta = {
    description = "A webpage bookmarking and snapshotting service";
    homepage = "https://github.com/asciimoo/omnom";
    license = lib.licenses.agpl3Only;
    maintainers = [
      # maintained by the team working on NGI-supported software, no group for this yet
    ];
    mainProgram = "omnom";
  };
}
