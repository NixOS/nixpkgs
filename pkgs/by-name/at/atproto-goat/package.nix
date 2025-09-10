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
    repo = "goat";
    rev = "e79169f1d8fba9838274b1106d74751fc54eeb9c";
    hash = "sha256-cLS44J6MlSSti7NRd9vSsdWXoYiMGwt3odg5p60W6ew=";
  };

  postPatch = ''
    substituteInPlace main.go \
      --replace-fail "versioninfo.Short()" '"${version}"' \
      --replace-fail '"github.com/earthboundkid/versioninfo/v2"' ""
  '';

  vendorHash = "sha256-l9oSdTAO1YxfrBjMWJDzlmhaZkbo90FGTk5LedjbZB8=";

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Go AT protocol CLI tool";
    homepage = "https://github.com/bluesky-social/goat/blob/main/README.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "goat";
  };
}
