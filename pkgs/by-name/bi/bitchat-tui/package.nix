{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bitchat-tui";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "vaibhav-mattoo";
    repo = "bitchat-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dk2VGXoOjs+cT8yKIsdhPSi8RG5WGN3Bi97ZW2dXQfA=";
  };

  cargoHash = "sha256-ynV/VGSDCCE06uOpNwBhb8wPgriS3KbVeTOnnn75u7U=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Secure, anonymous, P2P Bluetooth chat in your terminal.";
    longDescription = ''
      A modern Terminal User Interface (TUI) client for BitChat, a
      secure, anonymous, and peer-to-peer chat protocol that runs over
      Bluetooth Low Energy (BLE). Communicate completely off-grid with
      end-to-end encryption, public channels, and direct messaging,
      all from your terminal.
    '';
    homepage = "https://github.com/vaibhav-mattoo/bitchat-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "bitchat-tui";
  };
})
