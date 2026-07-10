{
  lib,
  cedar,
  testers,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cedar";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "cedar-policy";
    repo = "cedar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9IJ/AMWOtkNAoBbzTKqUZI87MvHPihdhNBwsmn0qpDA=";
  };

  cargoHash = "sha256-sinfwdi3/ZFmdbxRiUbtmhsVGcJenn82HFu8mJz415I=";

  cargoBuildFlags = [
    "--bin"
    "cedar"
  ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

  preCheck = ''
    export TMPDIR="/tmp"
  '';

  passthru = {
    tests.version = testers.testVersion { package = cedar; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Implementation of the Cedar Policy Language";
    homepage = "https://github.com/cedar-policy/cedar";
    changelog = "https://github.com/cedar-policy/cedar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ meain ];
    mainProgram = "cedar";
  };
})
