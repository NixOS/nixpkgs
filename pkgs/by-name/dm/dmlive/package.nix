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
  version = "5.5.8-unstable-2025-04-06";

  src = fetchFromGitHub {
    owner = "THMonster";
    repo = "dmlive";
    rev = "b066a637093871de9962e08d4f0ae0b77bd8f1f4"; # no tag
    hash = "sha256-pAsxr6zGCDZ0qysGT1+2+5+WKI2QopGxnZWpfnxk/fI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GVko8GK5Muha4uqDMgk7VkFoFCVcmk0vM1GUELvSzgM=";

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
