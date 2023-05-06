{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, protobuf
, libsecret
, libadwaita
, rustPlatform
, desktop-file-utils
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "flare";
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "Schmiddiii";
    repo = pname;
    rev = version;
    hash = "sha256-wY95sXWGDjEy8vvP79XliJOn5GQkAvDmOXKmRz0TPEw=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "curve25519-dalek-3.2.1" = "sha256-T/NGZddFQWq32eRu6FYfgdPqU8Y4Shi1NpMaX4GeQ54=";
      "libsignal-protocol-0.1.0" = "sha256-gapAurbs/BdsfPlVvWWF7Ai1nXZcxCW8qc5gQdbnthM=";
      "libsignal-service-0.1.0" = "sha256-AXWCR1maqgIPk8H/IKR22BvMToqJrtlaOelFAnMJ6kI=";
      "presage-0.4.0" = "sha256-HtqSNEaQXgvgrs9xvm76W1v7PLmdsJ5M3fbqH2Dpw8A=";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils # for update-desktop-database
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    libadwaita
    libsecret
    protobuf
  ];

  meta = {
    changelog = "https://gitlab.com/Schmiddiii/flare/-/blob/${src.rev}/CHANGELOG.md";
    description = "An unofficial Signal GTK client";
    homepage = "https://gitlab.com/Schmiddiii/flare";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda tomfitzhenry ];
    platforms = lib.platforms.linux;
  };
}
