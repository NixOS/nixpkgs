{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  go-task,
}:

buildGoModule rec {
  pname = "arduino-create-agent";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "arduino-create-agent";
    rev = "${version}";
    hash = "sha256-L77LDMe6KTwQ2qAx3OT1O27h4DhAjZzcs8WL/N7E8hI=";
  };

  patches = [
    ./updater.patch
  ];

  vendorHash = "sha256-Nrw7l3nV1sMVWs1HECQJYohKiD0gPvWQOLD7eohEd1A=";

  ldflags = [
    "-X github.com/arduino/arduino-create-agent/version.versionString=${version}"
    "-X github.com/arduino/arduino-create-agent/version.commit=unknown"
  ];

  doCheck = false; # require network connectivity

  meta = {
    description = "Agent to upload code to any USB connected Arduino board directly from the browser";
    homepage = "https://github.com/arduino/arduino-create-agent";
    changelog = "https://github.com/arduino/arduino-create-agent/releases/tag/${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ kilimnik ];
  };
}
