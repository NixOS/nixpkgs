{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "workstyle";
  version = "unstable-2023-08-23";

  src = fetchFromGitHub {
    owner = "pierrechevalier83";
    repo = pname;
    rev = "8bde72d9a9dd67e0fc7c0545faca53df23ed3753";
    sha256 = "sha256-yhnt7edhgVy/cZ6FpF6AZWPoeMeEKTXP+87no2KeIYU=";
  };

  cargoLock = {
    lockFile = ./workstyle-Cargo.lock;
    outputHashes = {
      "swayipc-3.0.1" = "sha256-3Jhz3+LhncSRvo3n7Dh5d+RWQSvEff9teuaDZLLLEHk=";
    };
  };

  doCheck = false; # No tests

  meta = with lib; {
    description = "Sway workspaces with style";
    homepage = "https://github.com/pierrechevalier83/workstyle";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
