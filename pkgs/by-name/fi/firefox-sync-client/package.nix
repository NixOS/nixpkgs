{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "firefox-sync-client";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "Mikescher";
    repo = "firefox-sync-client";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hZ6sd/IM/X8WWNc1ca7w1R4fsixo5VMGEujmPJvEMQc=";
  };

  vendorHash = "sha256-NQKF5LugGh2wNWf6M3uUhS2YOTuv2/K56gWUv5ACwEU=";

  meta = {
    description = "Commandline-utility to list/view/edit/delete entries in a firefox-sync account";
    homepage = "https://github.com/Mikescher/firefox-sync-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "ffsclient";
  };
})
