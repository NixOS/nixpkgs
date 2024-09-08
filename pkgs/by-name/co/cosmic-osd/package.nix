{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, libxkbcommon
, pulseaudio
, udev
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-osd";
  version = "1.0.0-alpha.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "epoch-${version}";
    hash = "sha256-JDdVFNTJI9O88lLKB1esJE4sk7ZZnTMilQRZSAgnTqs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-config-0.1.0" = "sha256-mdRRfXLyDBYQIPmbuXgXGoOKUlyw6CiSmOUBz1b3vJY=";
      "cosmic-settings-subscriptions-0.1.0" = "sha256-6lruTGNla1sEcQXxyaAZJj3Jg3xrqjN0ylmQpz+cyD0=";
      "cosmic-text-0.12.0" = "sha256-x7UMzlzYkWySFgSQTO1rRn+pyPG9tXKpJ7gzx/wpm8U=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "iced_accessibility-0.1.0" = "sha256-QT1e8W8cbMQ9jrJSEWoGGoo0TGi2+DS9n9hnKj+B5fM=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "upower_dbus-0.3.2" = "sha256-LU06/xPKfOxlLgOJIOz5iQuoMspH3ddD1wHNylO+380=";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxkbcommon pulseaudio wayland udev ];

  env.POLKIT_AGENT_HELPER_1 = "/run/wrappers/bin/polkit-agent-helper-1";

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    mainProgram = "cosmic-osd";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
