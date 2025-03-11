{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  makeWrapper,
  openssl,
  mpv,
  ffmpeg_6,
  nodejs,
}:

let
  desktop = fetchurl {
    url = "https://github.com/THMonster/Revda/raw/e1c236f6f940443419b6202735b6f8a0c9cdbe8b/misc/dmlive-mime.desktop";
    hash = "sha256-k4h0cSfjuTZAYLjbaTfcye1aC5obd6D3tAZjgBV8xCI=";
  };
in

rustPlatform.buildRustPackage {
  pname = "dmlive";
  version = "5.5.7-unstable-2025-01-25";

  src = fetchFromGitHub {
    owner = "THMonster";
    repo = "dmlive";
    rev = "79b4d9430fca3ebb86c57ee506989f620ea68a21"; # no tag
    hash = "sha256-0DDKKd4IZj+3AyVMG4FXjCbvvMg5iDCiF1B6nB8n3lU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-UwKQivYZyXYADbwf4VA1h2y7YzpxefUgDYQG+NaLMwE=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ];

  postInstall = ''
    wrapProgram "$out/bin/dmlive" --suffix PATH : "${
      lib.makeBinPath [
        mpv
        ffmpeg_6
        nodejs
      ]
    }"
    install -Dm644 ${desktop} $out/share/applications/dmlive-mime.desktop
  '';

  env.OPENSSL_NO_VENDOR = true;

  meta = {
    description = "Tool to play and record videos or live streams with danmaku";
    homepage = "https://github.com/THMonster/dmlive";
    license = lib.licenses.mit;
    mainProgram = "dmlive";
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
