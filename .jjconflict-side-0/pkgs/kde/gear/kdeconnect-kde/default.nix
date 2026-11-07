{
  lib,
  mkKdeDerivation,
  replaceVars,
  sshfs,
  qtbase,
  qtconnectivity,
  qtmultimedia,
  pkg-config,
  wayland,
  wayland-protocols,
  libei,
  libevdev,
  libfakekey,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "kdeconnect-kde";

  patches = [
    (replaceVars ./hardcode-sshfs-path.patch {
      sshfs = lib.getExe sshfs;
    })

    # backport fixes for udev rule install path
    (fetchpatch {
      url = "https://invent.kde.org/network/kdeconnect-kde/-/commit/a0d71485a540270421261e05cbe9102a0031ec34.diff";
      hash = "sha256-Klfz3a4AfUMNGWqk/E8xqRvqg7Wn0PrB9+aYmUHoNGM=";
    })
    (fetchpatch {
      url = "https://invent.kde.org/network/kdeconnect-kde/-/commit/e00d56efce0409a4a7905f7f105d06d5c96031d0.diff";
      hash = "sha256-nRaQSR/jKHgaiSmrJaYNqSI0Hd2QmtwHWUZY8TeL/2Y=";
    })
  ];

  # Hardcoded as a QString, which is UTF-16 so Nix can't pick it up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${sshfs}" > $out/nix-support/depends
  '';

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtconnectivity
    qtmultimedia
    wayland
    wayland-protocols
    libei
    libevdev
    libfakekey
  ];

  extraCmakeFlags = [
    "-DQtWaylandScanner_EXECUTABLE=${qtbase}/libexec/qtwaylandscanner"
  ];
}
