{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, alsa-lib
, flac
, nix-update-script
}:

buildGoModule rec {
  pname = "go-musicfox";
<<<<<<< HEAD
  version = "4.1.4";
=======
  version = "4.0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "go-musicfox";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-z4zyLHflmaX5k69KvPTISRIEHVjDmEGZenNXfYd3UUk=";
=======
    hash = "sha256-ZqB3NL/pLIY1lHl3qMIOciqsOW9jNwjVQAq1j/ydDWs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  deleteVendor = true;

<<<<<<< HEAD
  vendorHash = "sha256-S1OIrcn55wm/b7B3lz55guuS+mrv5MswNMO2UyfgjRc=";
=======
  vendorHash = "sha256-rJlyrPQS9UKinxIwGGo3EHlmWrzTKIm1jM1UDqnmVyg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/musicfox.go" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/go-musicfox/go-musicfox/pkg/constants.AppVersion=${version}"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    flac
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Terminal netease cloud music client written in Go";
    homepage = "https://github.com/anhoder/go-musicfox";
    license = licenses.mit;
    mainProgram = "musicfox";
    maintainers = with maintainers; [ zendo Ruixi-rebirth aleksana ];
  };
}
