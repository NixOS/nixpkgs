{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mpdris2-rs";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "szclsya";
    repo = "mpdris2-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E9H6bjmWZx35fZo/ZPvJL1w/YQ34pJ7z81YbB5fUZSU=";
  };
  cargoHash = "sha256-rA/za8fc2RiURaiijc49y+2QBcS6cDavZQFjVh+7Iow=";

  postPatch = ''
    substituteInPlace misc/mpdris2-rs.service --replace-fail "/usr/local" "$out"
  '';

  postInstall = ''
    install -Dm644 misc/mpdris2-rs.service -t $out/lib/systemd/user
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Exposing MPRIS V2.2 D-Bus interface for MPD";
    longDescription = ''
      A lightweight implementation of MPD to D-Bus bridge, which exposes MPD
      player and playlist information onto MPRIS2 interface so other programs
      can use this generic interface to retrieve MPD's playback state.
    '';
    homepage = "https://github.com/szclsya/mpdris2-rs";
    changelog = "https://github.com/szclsya/mpdris2-rs/blob/${finalAttrs.src.rev}/Changes.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      acidbong
    ];
    mainProgram = "mpdris2-rs";
  };
})
