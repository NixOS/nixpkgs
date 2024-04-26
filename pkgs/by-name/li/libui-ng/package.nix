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
  version = "unstable-2024-02-05";

  src = fetchFromGitHub {
    owner = "libui-ng";
    repo = "libui-ng";
    rev = "4d46de31eafad84c88b939356bcd64e6c5ee3821";
    hash = "sha256-Yb8VdJe75uBzRnsfTOVxUXstZmu6dJ9nBuOrf86KO5s=";
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

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A portable GUI library for C";
    homepage = "https://github.com/libui-ng/libui-ng";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
