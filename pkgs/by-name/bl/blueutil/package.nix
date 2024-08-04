{
  lib,
  stdenv,
  fetchFromGitHub,
  darwin,
  testers,
  nix-update-script,
}:

let
  inherit (darwin.apple_sdk.frameworks) Foundation IOBluetooth;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "blueutil";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "toy";
    repo = "blueutil";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x2khx8Y0PolpMiyrBatT2aHHyacrQVU/02Z4Dz9fBtI=";
  };

  buildInputs = [
    Foundation
    IOBluetooth
  ];

  env.NIX_CFLAGS_COMPILE = "-Wall -Wextra -Werror -mmacosx-version-min=10.9 -framework Foundation -framework IOBluetooth";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 755 blueutil $out/bin/blueutil

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/toy/blueutil/blob/main/CHANGELOG.md";
    description = "CLI for bluetooth on OSX";
    homepage = "https://github.com/toy/blueutil";
    license = lib.licenses.mit;
    mainProgram = "blueutil";
    maintainers = with lib.maintainers; [ azuwis ];
    platforms = lib.platforms.darwin;
  };
})
