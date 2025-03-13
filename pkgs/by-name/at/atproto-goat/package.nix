{
  lib,
  buildGoModule,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildGoModule rec {
  pname = "atproto-goat";
  version = "0-unstable-2025-02-01";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "indigo";
    rev = "fd270fbccf0ca858ed2eccdeff246a303c0be045";
    hash = "sha256-1WK3tMz8WbuIGTHYwD0or+9D0KVezhnv3EDdK11KKp8=";
  };

  postPatch = ''
    substituteInPlace cmd/goat/main.go \
      --replace-fail "versioninfo.Short()" '"${version}"' \
      --replace-fail '"github.com/carlmjohnson/versioninfo"' ""
  '';

  vendorHash = "sha256-pGc29fgJFq8LP7n/pY1cv6ExZl88PAeFqIbFEhB3xXs=";

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
