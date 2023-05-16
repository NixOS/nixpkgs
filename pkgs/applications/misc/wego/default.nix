{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wego";
<<<<<<< HEAD
  version = "2.2";
=======
  version = "2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "schachmat";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-bkbH3RewlYYNamAhAZGWQmzNdGB06K3m/D8ScsQP9ic=";
  };

  vendorHash = "sha256-aXrXw/7ZtSZXIKDMZuWPV2zAf0e0lU0QCBhua7tHGEY=";
=======
    sha256 = "sha256-lMcrFwYtlnivNjSbzyiAEAVX6ME87yB/Em8Cxb1LUS4=";
  };

  vendorSha256 = "sha256-kv8c0TZdxCIfmkgCLDiNyoGqQZEKUlrNLEbjlG9rSPs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/schachmat/wego";
    description = "Weather app for the terminal";
    license = licenses.isc;
  };
}
