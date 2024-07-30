{ lib
, buildGoModule
, fetchFromGitHub
, unstableGitUpdater
}:

buildGoModule {
  pname = "corrupter";
  version = "1.0-unstable-2023-01-11";

  src = fetchFromGitHub {
    owner = "r00tman";
    repo = "corrupter";
    # https://github.com/r00tman/corrupter/issues/15
    rev = "d7aecbb8b622a2c6fafe7baea5f718b46155be15";
    hash = "sha256-GEia3wZqI/j7/dpBbL1SQLkOXZqEwanKGM4wY9nLIqE=";
  };

  vendorHash = null;

  # There are no tests available for this package.
  doCheck = false;

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = with lib; {
    description = "Simple image glitcher suitable for producing lockscreens";
    homepage = "https://github.com/r00tman/corrupter";
    license = licenses.bsd2;
    maintainers = [ maintainers.ivan770 ];
    mainProgram = "corrupter";
  };
}
