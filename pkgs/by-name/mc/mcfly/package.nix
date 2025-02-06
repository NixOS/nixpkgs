{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    hash = "sha256-KQgoyxzTWoQok/sUFcvUazxrBMxVXvxqjJudyKYeZCo=";
  };

  postPatch = ''
    substituteInPlace mcfly.bash --replace '$(command which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.zsh  --replace '$(command which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.fish --replace '(command which mcfly)'  '${placeholder "out"}/bin/mcfly'
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-+ko1ltt3a5rst4qbIMUeiq0/0Vmqf0cHt6wv8GSmC70=";

  meta = with lib; {
    homepage = "https://github.com/cantino/mcfly";
    description = "Upgraded ctrl-r where history results make sense for what you're working on right now";
    changelog = "https://github.com/cantino/mcfly/raw/v${version}/CHANGELOG.txt";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
    mainProgram = "mcfly";
  };
}
