{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "firefox-sync-client";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "Mikescher";
    repo = "firefox-sync-client";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vns6emsqNny9sDv76NKJh/JG8SJ7rje45S1bxHVsT7U=";
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
