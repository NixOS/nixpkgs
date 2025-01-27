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

  useFetchCargoVendor = true;
  cargoHash = "sha256-WP8ecsNHLjIUeoEDXO3WbIKuXZu24A1WBKzAq0x1tek=";

  passthru.tests = nixosTests.cntr;

  meta = with lib; {
    description = "Container debugging tool based on FUSE";
    homepage = "https://github.com/Mic92/cntr";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      mic92
      sigmasquadron
    ];
    mainProgram = "cntr";
  };
}
