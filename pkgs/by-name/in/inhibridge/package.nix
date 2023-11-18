{
  lib,
  rustPlatform,
  fetchFromGitea,
}:
rustPlatform.buildRustPackage rec {
  pname = "inhibridge";
  version = "0.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Scrumplex";
    repo = "inhibridge";
    rev = version;
    hash = "sha256-SfEJpszJJQHGwjl6Z/xJK3PusL7p3zG+xOVvs1kKjOs=";
  };

  cargoHash = "sha256-i9NlI0ElAMfEVsZHdZY5e5AwZYptb/vQf0ejhMnUTC4=";

  meta = with lib; {
    homepage = "https://codeberg.org/Scrumplex/inhibridge";
    description = "Simple daemon that bridges freedesktop.org ScreenSaver inhibitions to systemd-inhibit";
    platforms = platforms.unix;
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [Scrumplex];
    mainProgram = "inhibridge";
  };
}

