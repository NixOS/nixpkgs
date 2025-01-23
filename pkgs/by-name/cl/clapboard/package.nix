{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "clapboard";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "clapboard";
    rev = "v${version}";
    hash = "sha256-dXlUOIYgptYqUIIC7batc0TVQeP89i8vizwYSIUlzGA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TcOu+wReDfQl6pbRJjB/mG7VY65pIyyvSBxbj6RhNlU=";

  meta = with lib; {
    description = "Wayland clipboard manager that will make you clap";
    homepage = "https://github.com/bjesus/clapboard";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.linux;
    mainProgram = "clapboard";
  };
}
