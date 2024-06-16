{ lib
, stdenv
, cmocka
, darwin
, fetchFromGitHub
, gtk3
, meson
, ninja
, pkg-config
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "libui-ng";
  version = "4.1-unstable-2024-05-19";

  src = fetchFromGitHub {
    owner = "libui-ng";
    repo = "libui-ng";
    rev = "49b04c4cf8ae4d3e38e389f446ef75170eb62762";
    hash = "sha256-W9LnUBUKwx1x3+BEeUanisBGR2Q4dnbcMM5k8mCondM=";
  };

  postPatch = lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    substituteInPlace meson.build --replace "'-arch', 'arm64'" ""
  '';

  nativeBuildInputs = [
    cmocka
    meson
    ninja
    pkg-config
  ];

  buildInputs =
    if stdenv.isDarwin then [
      darwin.libobjc
      darwin.apple_sdk_11_0.Libsystem
      darwin.apple_sdk_11_0.frameworks.Cocoa
      darwin.apple_sdk_11_0.frameworks.AppKit
      darwin.apple_sdk_11_0.frameworks.CoreFoundation
    ] else [
      gtk3
    ];

  mesonFlags = [
    (lib.mesonBool "examples" (!stdenv.isDarwin))
  ];

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "alpha";
  };

  meta = with lib; {
    description = "A portable GUI library for C";
    homepage = "https://github.com/libui-ng/libui-ng";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
