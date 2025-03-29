{
  lib,
  stdenv,
  cmocka,
  darwin,
  fetchFromGitHub,
  gtk3,
  meson,
  ninja,
  pkg-config,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "libui-ng";
  version = "4.1-unstable-2025-03-15";

  src = fetchFromGitHub {
    owner = "libui-ng";
    repo = "libui-ng";
    rev = "43ba1ef553c8993a43a67f1ce6e35983a2660d8c";
    hash = "sha256-pnfrSPDIvG0tFYQoeMBONATkNRNjY/tJGp9n2I4cN/U=";
  };

  postPatch = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    substituteInPlace meson.build --replace "'-arch', 'arm64'" ""
  '';

  nativeBuildInputs = [
    cmocka
    meson
    ninja
    pkg-config
  ];

  buildInputs =
    if stdenv.hostPlatform.isDarwin then
      [
        darwin.libobjc
        darwin.apple_sdk_11_0.Libsystem
        darwin.apple_sdk_11_0.frameworks.Cocoa
        darwin.apple_sdk_11_0.frameworks.AppKit
        darwin.apple_sdk_11_0.frameworks.CoreFoundation
      ]
    else
      [
        gtk3
      ];

  mesonFlags = [
    (lib.mesonBool "examples" (!stdenv.hostPlatform.isDarwin))
  ];

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "alpha";
  };

  meta = with lib; {
    description = "Portable GUI library for C";
    homepage = "https://github.com/libui-ng/libui-ng";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
