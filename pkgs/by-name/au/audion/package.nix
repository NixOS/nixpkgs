{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "audion";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "audiusGmbH";
    repo = "audion";
    tag = version;
    hash = "sha256-NtAzh7n5bJXMt73L+FJU3vuNoNgga3wYXdZ2TY8AjIA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kIrbHt6aAUgdF4Jx/aUOYpiBj1+pyFLCVak6R+JN2Ug=";

  meta = with lib; {
    description = "Ping the host continuously and write results to a file";
    homepage = "https://github.com/audiusGmbH/audion";
    changelog = "https://github.com/audiusGmbH/audion/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "audion";
  };
}
