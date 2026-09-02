{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprproxlock";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Da4ndo";
    repo = "hyprproxlock";
    tag = finalAttrs.version;
    hash = "sha256-v0EiUMOmyKyVwskit5Wp3lu0kwOscDbVgGldcP6xfek=";
  };

  cargoHash = "sha256-jpLNgqwQq58M+mbPK4sdlm5Lf1Pgywr8A8Z1bEU3DOw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  preCheck = ''
    patchShebangs --build tests/mocks
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Da4ndo/hyprproxlock";
    description = "Proximity-based daemon for Hyprland that triggers screen locking and unlocking through hyprlock based on Bluetooth device proximity";
    longDescription = ''
      A proximity-based daemon for Hyprland that triggers screen locking and unlocking through hyprlock based on Bluetooth device proximity.
      It monitors connected devices' signal strength to automatically control your screen lock state.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ shymega ];
    mainProgram = "hyprproxlock";
  };
})
