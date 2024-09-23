{
  lib,
  rustPlatform,
  fetchFromGitea,
}:
rustPlatform.buildRustPackage rec {
  pname = "inhibridge";
  version = "0.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Scrumplex";
    repo = "inhibridge";
    rev = version;
    hash = "sha256-cKVw3Gd4Ml8BeXjZqTN6ToeRzO9PI+Sn45gpltlRuWM=";
  };

  cargoHash = "sha256-uKSbxAsGUR2nYfdtiTR/bgPBQunqYLzx3+CmszNilPQ=";

  meta = with lib; {
    homepage = "https://codeberg.org/Scrumplex/inhibridge";
    description = "Simple daemon that bridges freedesktop.org ScreenSaver inhibitions to systemd-inhibit";
    platforms = platforms.linux;
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [Scrumplex];
    mainProgram = "inhibridge";
  };
}

