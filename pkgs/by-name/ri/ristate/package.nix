{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage rec {
  pname = "ristate";
  version = "unstable-2021-09-10";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = pname;
    rev = "34dfd0a0bab5b36df118d8da3956fd938c625b15";
    hash = "sha256-CH9DZ/7Bhbe6qKg1Nbj1rA9SzIsqVlBJg51XxAh0XnY=";
  };

  cargoHash = "sha256-HTfRWvE3m7XZhZDj5bEkrQI3pD6GNiKd2gJtMjRQ8Rw=";

  meta = with lib; {
    description = "River-status client written in Rust";
    homepage = "https://gitlab.com/snakedye/ristate";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
    mainProgram = "ristate";
  };
}
