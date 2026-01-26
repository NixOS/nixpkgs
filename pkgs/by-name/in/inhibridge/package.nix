{
  lib,
  rustPlatform,
  fetchFromCodeberg,
}:
rustPlatform.buildRustPackage rec {
  pname = "inhibridge";
  version = "0.3.0";

  src = fetchFromCodeberg {
    owner = "Scrumplex";
    repo = "inhibridge";
    rev = version;
    hash = "sha256-cKVw3Gd4Ml8BeXjZqTN6ToeRzO9PI+Sn45gpltlRuWM=";
  };

  cargoHash = "sha256-bW0+oZJO4JFgDuLl5f7iVorSyN/ro+BRSTX0j15Oqb4=";

  meta = {
    homepage = "https://codeberg.org/Scrumplex/inhibridge";
    description = "Simple daemon that bridges freedesktop.org ScreenSaver inhibitions to systemd-inhibit";
    platforms = lib.platforms.linux;
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ Scrumplex ];
    mainProgram = "inhibridge";
  };
}
