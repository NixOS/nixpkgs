{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mpdris2-rs";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "szclsya";
    repo = "mpdris2-rs";
    rev = version;
    hash = "sha256-0m1nRanzqzhu6dKDvHFX4srfBTLyh5ln6sVBWBGxxw0=";
  };

  cargoHash = "sha256-WYk9vXhgAepitO3Smv/zxYt+V+aiB786cCfOcaGruQQ=";

  postInstall = ''
    install -Dm644 misc/mpdris2-rs.service -t $out/share/systemd/user
  '';

  meta = {
    description = "Exposing MPRIS V2.2 D-Bus interface for mpd";
    homepage = "https://github.com/szclsya/mpdris2-rs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "mpdris2-rs";
  };
}
