{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libevdev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "evsieve";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "KarsMulder";
    repo = "evsieve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UV5m8DmFtkCU/DoBJNBCdvhU/jYtU5+WnnhKwxZNl9g=";
  };

  cargoHash = "sha256-rOqjB/ZakXhuKgN3auEOGzV+9bDX30TTZWD8nt3b+pE=";

  buildInputs = [ libevdev ];

  doCheck = false; # unit tests create uinput devices

  meta = {
    description = "Utility for mapping events from Linux event devices";
    mainProgram = "evsieve";
    homepage = "https://github.com/KarsMulder/evsieve";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tsowell ];
    platforms = lib.platforms.linux;
  };
})
