{ lib
, stdenv
, cmocka
, darwin
, fetchFromGitHub
, gtk3
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libui-ng";
  version = "unstable-2023-12-19";

  src = fetchFromGitHub {
    owner = "libui-ng";
    repo = "libui-ng";
    rev = "8de4a5c8336f82310df1c6dad51cb732113ea114";
    hash = "sha256-ZMt2pEHwxXxLWtK8Rm7hky9Kxq5ZIB0olBLf1d9wVfc=";
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

  meta = with lib; {
    description = "A portable GUI library for C";
    homepage = "https://github.com/libui-ng/libui-ng";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
    platforms = platforms.all;
  };
}
