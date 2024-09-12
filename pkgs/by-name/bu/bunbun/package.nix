{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
  nix-update-script,
  testers,
  bunbun,
}:

rustPlatform.buildRustPackage rec {
  pname = "bunbun";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "devraza";
    repo = "bunbun";
    # TODO: remove '-bump' at next release
    rev = "refs/tags/v${version}-bump";
    hash = "sha256-r4xBUfNY+Q3uAC919ZQbIDgiF981FVqZCOT8XNojZP4=";
  };

  cargoHash = "sha256-CcGfaSyCMv0Wm4QsYASBwEnpX8fKbLHRqyEcUmj2w2o=";

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      CoreFoundation
      IOKit
      SystemConfiguration
    ]
  );

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = bunbun; };
  };

  meta = {
    description = "Simple and adorable sysinfo utility written in Rust";
    homepage = "https://github.com/devraza/bunbun";
    changelog = "https://github.com/devraza/bunbun/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "bunbun";
  };
}
