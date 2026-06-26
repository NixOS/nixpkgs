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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "InputUsername";
    repo = "rescrobbled";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pk8eWq3GOF0f6Xvt4VJezxW+vWnfk7W0sKn+Yvd7PHs=";
  };

  cargoHash = "sha256-EpQoi/pPIJN5sOZic/J8A3Co4o27Gi2SW/OaZHBFU2Y=";

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
