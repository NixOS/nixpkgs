{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  makeWrapper,
  openssl,
  mpv,
  ffmpeg,
}:

let
  desktop = fetchurl {
    url = "https://github.com/THMonster/Revda/raw/e1c236f6f940443419b6202735b6f8a0c9cdbe8b/misc/dmlive-mime.desktop";
    hash = "sha256-k4h0cSfjuTZAYLjbaTfcye1aC5obd6D3tAZjgBV8xCI=";
  };
in

rustPlatform.buildRustPackage {
  pname = "dmlive";
  version = "5.7.0-unstable-2026-01-02";

  src = fetchFromGitHub {
    owner = "THMonster";
    repo = "dmlive";
    rev = "47b06e57fc0fa9cf888f7c054f776a73d65e77ce"; # no tag
    hash = "sha256-Q1QOJZ6VW65MG0wzJAgW9p4mF6a48qYRdDaeQyDTbk8=";
  };

  cargoHash = "sha256-hRJ81Opxh3tHHZAVTXzQKTmv+psbeGW1KHyoRBfnnWI=";

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
        ffmpeg
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
    maintainers = with lib.maintainers; [
      nickcao
      rebmit
    ];
  };
}
