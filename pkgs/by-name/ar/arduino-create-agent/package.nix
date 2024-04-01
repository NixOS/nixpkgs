{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, go-task
, darwin
}:

buildGoModule rec {
  pname = "arduino-create-agent";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "arduino-create-agent";
    rev = "${version}";
    hash = "sha256-7qKBFm/4uriyNguhhb28uE8w4k9qV0uKwJNhQ3bBbk8=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AppKit
    Cocoa
  ]);

  patches = [
    ./updater.patch
  ];

  vendorHash = "sha256-L5fDyDJzTV9TsgbFkhO11PirrFSdHxEGWiaFf1vTEDo=";

  ldflags = [
    "-X github.com/arduino/arduino-create-agent/version.versionString=${version}"
    "-X github.com/arduino/arduino-create-agent/version.commit=unknown"
  ];

  doCheck = false;

  meta = with lib; {
    description = "The Arduino Create Agent";
    homepage = "https://github.com/arduino/arduino-create-agent";
    changelog = "https://github.com/arduino/arduino-create-agent/releases/tag/${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ kilimnik ];
  };
}
