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

  cargoHash = "sha256-Ll2fpH0v3ZWizrl6Mip0gaPCHlQAdddh9F9bNXveb/0=";

  meta = with lib; {
    description = "Wayland clipboard manager that will make you clap";
    homepage = "https://github.com/bjesus/clapboard";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.linux;
    mainProgram = "clapboard";
  };
}
