{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, fontconfig
, xorg
, libGL
, openssl
, AppKit
, ApplicationServices
, CoreFoundation
, CoreGraphics
, CoreServices
, CoreText
, CoreVideo
, Foundation
, Metal
, QuartzCore
, Security
, libobjc
}:

rustPlatform.buildRustPackage rec {
  pname = "inlyne";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "trimental";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jFocERr2cW7zdLiYfAay5Dh1issKAHp6vRWYWR1Axcg=";
  };

  cargoSha256 = "sha256-mH8tu8koprmHo6JJ9AwYMexy2SFR2yukZmFT060cuZ4=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [
    fontconfig
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libxcb
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    ApplicationServices
    CoreFoundation
    CoreGraphics
    CoreServices
    CoreText
    CoreVideo
    Foundation
    Metal
    QuartzCore
    Security
    libobjc
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/inlyne \
      --add-rpath ${lib.makeLibraryPath [ libGL xorg.libX11 ]}
  '';

  meta = with lib; {
    description = "A GPU powered browserless markdown viewer";
    homepage = "https://github.com/trimental/inlyne";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
