{ lib, buildGoModule, fetchFromGitHub, testers, spicetify-cli }:

buildGoModule rec {
  pname = "spicetify-cli";
<<<<<<< HEAD
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "spicetify-cli";
    rev = "v${version}";
    hash = "sha256-j20B980kSsAh9uEOQp9a0URA32GtRCAH5N0I5OoEzuQ=";
  };

  vendorHash = "sha256-cRauedoHANgbN9b/VAdmm5yF/2qMuQhXjitOnJoyaDs=";
=======
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-k9fbChpHy997Mj+U9n/iiSGDdsHZ22AoYUkCHUMGfbo=";
  };

  vendorHash = "sha256-mAtwbYuzkHUqG4fr2JffcM8PmBsBrnHWyl4DvVzfJCw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s -w"
    "-X 'main.version=${version}'"
  ];

  # used at runtime, but not installed by default
  postInstall = ''
    cp -r ${src}/jsHelper $out/bin/jsHelper
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/spicetify-cli --help > /dev/null
  '';

  passthru.tests.version = testers.testVersion {
    package = spicetify-cli;
    command = "spicetify-cli -v";
  };

  meta = with lib; {
    description = "Command-line tool to customize Spotify client";
    homepage = "https://github.com/spicetify/spicetify-cli/";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ jonringer mdarocha ];
    mainProgram = "spicetify-cli";
=======
    maintainers = with maintainers; [ jonringer ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
