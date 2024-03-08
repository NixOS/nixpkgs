{ stdenv
, rustPlatform
, fetchFromGitHub
, lib
, darwin
, glib
, gtk4
, libadwaita
, libX11
, libXtst
, pkg-config
, wrapGAppsHook4
}:

rustPlatform.buildRustPackage rec {
  pname = "lan-mouse";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "feschber";
    repo = "lan-mouse";
    rev = "v${version}";
    hash = "sha256-98n0Y9oL/ll90NKHJC/25wkav9K+eVqrO7PlrJMoGmY=";
  };

  nativeBuildInputs = [
    glib # needed in both {b,nativeB}uildInptus
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libX11
    libXtst
  ]
  ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.CoreGraphics;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "reis-0.1.0" = "sha256-sRZqm6QdmgqfkTjEENV8erQd+0RL5z1+qjdmY18W3bA=";
    };
  };

  meta = {
    description = "A software KVM switch for sharing a mouse and keyboard with multiple hosts through the network";
    homepage = "https://github.com/feschber/lan-mouse";
    changelog = "https://github.com/feschber/lan-mouse/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "lan-mouse";
    maintainers = with lib.maintainers; [ pedrohlc ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
