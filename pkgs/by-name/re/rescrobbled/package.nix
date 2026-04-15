{
  lib,
  dash,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {

  pname = "rescrobbled";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "InputUsername";
    repo = "rescrobbled";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/p9SY4XZNXl1ApB2gI8PMAp53lOBl0gcSPybRJe5MtE=";
  };

  cargoHash = "sha256-1uQiMn8X5joyBcIbzTDVM7GQB6Ks/jaEuSb4KR3hBW0=";

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

  meta = {
    description = "MPRIS music scrobbler daemon";
    homepage = "https://github.com/InputUsername/rescrobbled";
    license = lib.licenses.gpl3Plus;
    mainProgram = "rescrobbled";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ negatethis ];
  };
})
