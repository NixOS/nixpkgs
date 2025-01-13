{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  go-task,
}:

buildGoModule rec {
  pname = "arduino-create-agent";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "arduino-create-agent";
    rev = "${version}";
    hash = "sha256-TWyjF/2F3ub+sGFOTWc3kv2w6SRrvDaBSztOki32oxc=";
  };

  patches = [
    ./updater.patch
  ];

  vendorHash = "sha256-SV0Cw0MrAufBleloG1m4qNPme03cBj0UgQGL7jY1wY4=";

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
