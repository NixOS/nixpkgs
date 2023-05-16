{ lib, stdenv, fetchFromGitHub, buildGoModule, testers, podman-tui }:

buildGoModule rec {
  pname = "podman-tui";
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-tui";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-XaZgvy8b/3XUjO/GAQV6fxfqlR+eSMeosC7ugoYsEJM=";
=======
    hash = "sha256-0iI417mwmwph4wjuusaWY0kGtVsQy7i+eZvE1tYiINY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  CGO_ENABLED = 0;

  tags = [ "containers_image_openpgp" "remote" ]
    ++ lib.optional stdenv.isDarwin "darwin";

  ldflags = [ "-s" "-w" ];

  preCheck =
    let
      skippedTests = [
        "TestDialogs"
      ];
    in
    ''
      export USER=$(whoami)
      export HOME=/home/$USER

      # Disable flaky tests
      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
    '';

  passthru.tests.version = testers.testVersion {
    package = podman-tui;
    command = "podman-tui version";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/containers/podman-tui";
    description = "Podman Terminal UI";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
