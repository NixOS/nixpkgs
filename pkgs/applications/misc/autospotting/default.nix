{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "autospotting";
<<<<<<< HEAD
  version = "unstable-2023-07-03";

  src = fetchFromGitHub {
    owner = "LeanerCloud";
    repo = "AutoSpotting";
    rev = "6b08f61d72eafddf01bb68ccb789505f1c7be3eb";
    hash = "sha256-gW8AIPqwNXfjsPxPv/5+gF374wTw8iavhjmlG4Onkxg=";
  };

  vendorHash = "sha256-RuBchKainwE6RM3AphKWjndGZc1nh7A/Xxcacq1r7Nk=";
=======
  version = "unstable-2022-02-17";

  src = fetchFromGitHub {
    owner = "cloudutil";
    repo = "AutoSpotting";
    rev = "f295a1f86c4a21144fc7fe28a69da5668fb7ad0c";
    sha256 = "sha256-n5R5RM2fv3JWqtbSsyb7GWS4032dkgcihAKbpjB/5PM=";
  };

  vendorSha256 = "sha256-w7OHGZ7zntu8ZlI5gA19Iq7TKR23BQk9KpkUO+njL9Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  excludedPackages = [ "scripts" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Automatically convert your existing AutoScaling groups to up to 90% cheaper spot instances with minimal configuration changes";
    homepage = "https://github.com/cloudutil/AutoSpotting";
    license = licenses.osl3;
    maintainers = with maintainers; [ costrouc ];
    mainProgram = "AutoSpotting";
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
