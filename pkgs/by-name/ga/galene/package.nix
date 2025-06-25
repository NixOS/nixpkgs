{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "galene";
  version = "0.96.3";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    rev = "galene-${version}";
    hash = "sha256-loAiPfwTyPi4BKn4TNgVVde2mO119h443A+HwlLvi4g=";
  };

  vendorHash = "sha256-LDLKjD4qYn/Aae6GUX6gZ57+MUfKc058H+YHM0bNZV0=";

  ldflags = [
    "-s"
    "-w"
  ];
  preCheck = "export TZ=UTC";

  outputs = [
    "out"
    "static"
  ];

  postInstall = ''
    mkdir $static
    cp -r ./static $static
  '';

  passthru = {
    tests.vm = nixosTests.galene.basic;
  };

  meta = {
    description = "Videoconferencing server that is easy to deploy, written in Go";
    homepage = "https://github.com/jech/galene";
    changelog = "https://github.com/jech/galene/raw/galene-${version}/CHANGES";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.ngi ];
    maintainers = with lib.maintainers; [
      rgrunbla
      erdnaxe
    ];
  };
}
