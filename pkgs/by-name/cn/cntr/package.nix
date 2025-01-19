{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "cntr";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "cntr";
    rev = version;
    sha256 = "sha256-A622DfygwZ8HVgSxmPINkuCsYFKQBAUdsnXQmB/LS8w=";
  };

  cargoHash = "sha256-LRX7NuNLyEnw+2kj1MG4JvSL2jzVFxH6tMAx4+cCeow=";

  passthru.tests = nixosTests.cntr;

  meta = {
    description = "Container debugging tool based on FUSE";
    homepage = "https://github.com/Mic92/cntr";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mic92
      sigmasquadron
    ];
    mainProgram = "cntr";
  };
}
