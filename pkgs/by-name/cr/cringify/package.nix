{
  lib,
  rustPlatform,
  fetchFromGitHub,
  python3,
  testers,
  cringify,
}:

rustPlatform.buildRustPackage rec {
  pname = "cringify";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "sansyrox";
    repo = "cringify";
    rev = "857c2620ac9f1f53139d3a599e55679a75e77053";
    hash = "sha256-U0tKYFRZToMALSeItn9yia7Dl7omETDTkuRlWJ8EZEo=";
  };

  cargoHash = "sha256-OQXGn6m6VdSlxaCPRonjvEo/GOpsEiZkqL12UdoLu0Q=";

  postPatch = ''
    # Upstream doesn't set the version string itself
    substituteInPlace src/main.rs --replace '0.0.1' ${version}
  '';

  nativeBuildInputs = [ python3 ];

  # No tests are present in the repository
  doCheck = false;

  passthru.tests.version = testers.testVersion { package = cringify; };

  meta = {
    description = "Annoy your friends with the cringified text";
    homepage = "https://github.com/sansyrox/cringify";
    license = lib.licenses.mit;
    mainProgram = "cringify";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
