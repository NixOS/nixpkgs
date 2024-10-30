{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule rec {
  pname = "atproto-goat";
  version = "0-unstable-2024-10-08";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "indigo";
    rev = "06bacb465af714feb77609566aba15ab1ed41e24";
    hash = "sha256-wWsE3sAGZQmOBVqTgy4RjoU8zmtuvyQIj9DjwSbtmKw=";
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
