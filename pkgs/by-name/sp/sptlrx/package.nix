{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  sptlrx,
}:

buildGoModule rec {
  pname = "sptlrx";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "raitonoberu";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-G8nYJZkXTtpgyBXrSO16hDVfsi3rmS92SddpmVgNN7Y=";
  };

  vendorHash = "sha256-NHXR1jwVNha9yNbI//l2OZ7Lny+9X0nB/Sg5m5gJEiQ=";

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
      version = "v${version}"; # needed because testVersion uses grep -Fw
    };
  };

  meta = with lib; {
    description = "Spotify lyrics in your terminal";
    homepage = "https://github.com/raitonoberu/sptlrx";
    changelog = "https://github.com/raitonoberu/sptlrx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ MoritzBoehme ];
    mainProgram = "sptlrx";
  };
}
