{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

# TODO: This seems QGC specific; need to perform another overhaul to make it build independently
stdenv.mkDerivation (finalAttrs: {
  pname = "px4-gpsdrivers";
  version = "0-unstable-2025-03-25";

  src = fetchFromGitHub {
    owner = "PX4";
    repo = "PX4-GPSDrivers";
    rev = "4cea5de87ce7e2a52e5289bd3639fd8eb770eafa";
    hash = "sha256-4wqbfcbZvxBEaCPxA1hSxKTWE8tH/fkCJ+lcuPKCPsU=";
  };

  patches = [
    ./build-overhaul.patch # TODO: Upstream
  ];

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Platform independent GPS drivers";
    homepage = "https://github.com/PX4/PX4-GPSDrivers";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
