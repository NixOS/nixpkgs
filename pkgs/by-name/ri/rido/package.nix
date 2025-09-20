{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "rido";
  version = "0.6.0-unstable-2025-09-13";

  src = fetchFromGitHub {
    owner = "lj3954";
    repo = "rido";
    rev = "a1aa36a6108b34d2495256868b3b720170b8c306";
    hash = "sha256-welK63Bbckr6/OrA2BQmuVPfYVhkOgBttDnC7BlzP4U=";
  };

  cargoHash = "sha256-yKr6HW0PaNx1ha6yCuimebEf8oG9K0ug8lX5Gq+Cx9o=";

  meta = {
    description = "Fetch valid URLs and checksums of Microsoft Operating Systems";
    homepage = "https://github.com/lj3954/rido";
    license = lib.licenses.gpl3Plus;
    mainProgram = "rido";
    maintainers = with lib.maintainers; [ stv0g ];
  };
}
