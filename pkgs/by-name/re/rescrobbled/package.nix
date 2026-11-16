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
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "InputUsername";
    repo = "rescrobbled";
    rev = "v${finalAttrs.version}";
    hash = "sha256-q8zxv4fSk+rUG4zQkZFNgkqSU3+FqgTzJzzjeSHy3Io=";
  };

  cargoHash = "sha256-pWdA48WqcNd9/daZE7gyoGTkH01i3MBv1SMGdfE2ZS0=";

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
