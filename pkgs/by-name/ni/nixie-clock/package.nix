{
  fetchFromGitHub,
  lib,
  rustPlatform,
}: let
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "nixieClock";
    rev = "e6bde15c65b28da6318877bf0899aad915655b15";
    sha256 = "sha256-Lj98eghrucupnzdkMjGCPtGWO8NQ5ipQymsYUAl+XRU=";
  };
in
  rustPlatform.buildRustPackage {
    name = "nixie-clock";
    version = "1.0.0";
    inherit src;

    cargoLock.lockFile = "${src}/Cargo.lock";

    meta = with lib; {
      description = "A commandline clock inside nixie tubes";
      homepage = "https://github.com/NewDawn0/nixie-clock";
      maintainers = with maintainers; [NewDawn0];
      license = licenses.mit;
    };
  }
