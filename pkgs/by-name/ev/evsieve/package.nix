{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libevdev,
}:

rustPlatform.buildRustPackage rec {
  pname = "evsieve";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "KarsMulder";
    repo = "evsieve";
    rev = "v${version}";
    hash = "sha256-UV5m8DmFtkCU/DoBJNBCdvhU/jYtU5+WnnhKwxZNl9g=";
  };

  cargoHash = "sha256-rOqjB/ZakXhuKgN3auEOGzV+9bDX30TTZWD8nt3b+pE=";

  buildInputs = [ libevdev ];

  doCheck = false; # unit tests create uinput devices

  meta = with lib; {
    description = "Utility for mapping events from Linux event devices";
    mainProgram = "evsieve";
    homepage = "https://github.com/KarsMulder/evsieve";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ tsowell ];
    platforms = platforms.linux;
  };
}
