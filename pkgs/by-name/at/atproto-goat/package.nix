{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule rec {
  pname = "atproto-goat";
  version = "0-unstable-2024-10-29";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "indigo";
    rev = "983ce4a481a32a3eb2944c4c76e885d0f6006f83";
    hash = "sha256-Jo3pI4uRyKh3yV03ijOcg+Uyu75Spmy/VS116MVgleU=";
  };

  postPatch = ''
    substituteInPlace cmd/goat/main.go \
      --replace-fail "versioninfo.Short()" '"${version}"' \
      --replace-fail '"github.com/carlmjohnson/versioninfo"' ""
  '';

  vendorHash = "sha256-T+jtxubVKskrLGTUa4RI24o/WTSFCBk60HhyCFujPOI=";

  subPackages = [ "cmd/goat" ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Go AT protocol CLI tool";
    homepage = "https://github.com/bluesky-social/indigo/blob/main/cmd/goat/README.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "goat";
  };
}
