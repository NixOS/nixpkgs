{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "moji";
  version = "0.7.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Microck";
    repo = "moji";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qt5eNxXm30QMmryolfRObogMQwtxXuI3ylIRy+YEaho=";
  };

  vendorHash = "sha256-cCCwL7bqn+23YeLMiDEyCv+Gcu0xw068DgJDgaMb2tY=";

  subPackages = [ "cmd/moji" ];
  excludedPackages = [ "e2e" ];

  preCheck = ''
    unset subPackages
  '';

  checkFlags =
    let
      skippedTests = [
        "TestConfigCompactLayoutPutsValuesBelowLabels"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/microck/moji/internal/app.Version=${finalAttrs.version}"
    "-X github.com/microck/moji/internal/app.ReleaseMarker=moji-release-version:${finalAttrs.version}:moji-marker-end"
  ];

  meta = {
    description = "Find and download fonts from the terminal";
    homepage = "https://github.com/Microck/moji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yarn ];
    mainProgram = "moji";
  };
})
