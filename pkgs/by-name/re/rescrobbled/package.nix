{
  lib,
  dash,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  dbus,
}:

rustPlatform.buildRustPackage rec {

  pname = "rescrobbled";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "InputUsername";
    repo = "rescrobbled";
    rev = "v${version}";
    hash = "sha256-+5BkM4L2eB54idZ6X2ESw6ERMhG5CM4AF4BMEJm3xLU=";
  };

  cargoHash = "sha256-ZawdZdP87X7xMdSdZ1VJDJxz7dBGVYo+8jR8qb2Jgq8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    dbus
  ];

  postPatch = ''
    # Required for tests
    substituteInPlace src/filter.rs --replace-fail '#!/usr/bin/env sh' '#!${dash}/bin/dash'
  '';

  postInstall = ''
    substituteInPlace rescrobbled.service --replace-fail '%h/.cargo/bin/rescrobbled' "$out/bin/rescrobbled"
    install -Dm644 rescrobbled.service -t "$out/share/systemd/user"
  '';

  meta = with lib; {
    description = "MPRIS music scrobbler daemon";
    homepage = "https://github.com/InputUsername/rescrobbled";
    license = licenses.gpl3Plus;
    mainProgram = "rescrobbled";
    platforms = platforms.unix;
    maintainers = with maintainers; [ negatethis ];
  };
}
