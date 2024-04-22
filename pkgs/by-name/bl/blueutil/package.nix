{ lib
, stdenv
, fetchFromGitHub
, darwin
}:

let
  inherit (darwin.apple_sdk.frameworks) Foundation IOBluetooth;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "blueutil";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "toy";
    repo = "blueutil";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dxsgMwgBImMxMMD+atgGakX3J9YMO2g3Yjl5zOJ8PW0=";
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

  meta = {
    description = "CLI for bluetooth on OSX";
    homepage = "https://github.com/toy/blueutil";
    license = lib.licenses.mit;
    mainProgram = "blueutil";
    maintainers = with lib.maintainers; [ azuwis ];
    platforms = lib.platforms.darwin;
  };
})
