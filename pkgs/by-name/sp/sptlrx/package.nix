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
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "raitonoberu";
    repo = "sptlrx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QbF1yMzGGvxEUIMeQ6sI3ykXYW9R/2gFSRkrASbhiJ0=";
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
