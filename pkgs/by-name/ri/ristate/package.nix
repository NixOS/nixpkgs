{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage {
  pname = "ristate";
  version = "unstable-2021-09-10";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = "ristate";
    rev = "34dfd0a0bab5b36df118d8da3956fd938c625b15";
    hash = "sha256-CH9DZ/7Bhbe6qKg1Nbj1rA9SzIsqVlBJg51XxAh0XnY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kzy0U2ZdmEr/F1edQDM3S30ETXaVUXrSoUA+8v486O0=";

  meta = with lib; {
    description = "River-status client written in Rust";
    homepage = "https://gitlab.com/snakedye/ristate";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
    mainProgram = "ristate";
  };
}
