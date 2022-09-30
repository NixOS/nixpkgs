{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, fontconfig
, libXcursor
, libXi
, libXrandr
, libxcb
, libGL
, libX11
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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "trimental";
    repo = pname;
    rev = "v${version}";
    sha256 = "1y8nxz20agmrdcl25wry8lnpg86zbkkkkiscljwd7g7a831hlb9z";
  };

  cargoSha256 = "sha256-NXVwydEn4hX/4NorDx6eE+sWQXj1jwZgzpDE3wg8OkU=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [
    fontconfig
    libXcursor
    libXi
    libXrandr
    libxcb
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
      --add-rpath ${lib.makeLibraryPath [ libGL libX11 ]}
  '';

  meta = with lib; {
    description = "A GPU powered browserless markdown viewer";
    homepage = "https://github.com/trimental/inlyne";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
