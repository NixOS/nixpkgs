{ buildGoModule
, fetchFromGitHub
, lib
<<<<<<< HEAD
, testers
, faraday
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "faraday";
<<<<<<< HEAD
  version = "0.2.11-alpha";
=======
  version = "0.2.5-alpha";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "faraday";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KiGj24sBeClmzW60lRrvXwgXf3My7jhHTY+VhIMMp0k=";
  };

  vendorHash = "sha256-ku/4VE1Gj62vuJLh9J6vKlxpyI7S0RsMDozV7U5YDe4=";

  subPackages = [ "cmd/frcli" "cmd/faraday" ];

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = faraday;
  };

=======
    sha256 = "16mz333a6awii6g46gr597j31jmgws4285s693q0b87fl1ggj2zz";
  };

  vendorSha256 = "1nclmvypxp5436q6qaagp1k5bfmaia7hsykw47va0pijlsvsbmck";

  subPackages = [ "cmd/frcli" "cmd/faraday" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "LND Channel Management Tools";
    homepage = "https://github.com/lightninglabs/faraday";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
