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
  version = "5.6.0-unstable-2025-06-21";

  src = fetchFromGitHub {
    owner = "THMonster";
    repo = "dmlive";
    rev = "485eae06737530360c0e6f6415c62791767d595b"; # no tag
    hash = "sha256-0JjPZPtAtbxdh0HDycWHEonZggBcoqv5SJUnhKzXNIk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-B1v9m4Nn5wXMbNBlh7+A8zBejJ0tHdqvSXVpRz+wC5g=";

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
