{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  sptlrx,
}:

buildGoModule (finalAttrs: {
  pname = "sptlrx";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "raitonoberu";
    repo = "sptlrx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-X1nDvhW8F4UDWIeP0W6EtwB+0Ytf/d76oB/SJV9/neg=";
  };

  vendorHash = "sha256-2QbGrQwFA+YeoVt4se2silLYbg7cQGY/fCTQb2bXWAM=";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      # Requires network access
      skippedTests = [ "TestGetIndex" ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = sptlrx;
      version = "v${finalAttrs.version}"; # needed because testVersion uses grep -Fw
    };
  };

  meta = {
    description = "Spotify lyrics in your terminal";
    homepage = "https://github.com/raitonoberu/sptlrx";
    changelog = "https://github.com/raitonoberu/sptlrx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MoritzBoehme ];
    mainProgram = "sptlrx";
  };
})
