{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, makeWrapper
, pkg-config
, python3
, libGL
, libX11
, libXcursor
, libXi
, libXrandr
, libXxf86vm
, libxcb
, libxkbcommon
, wayland
, AppKit
, CoreGraphics
, CoreServices
, Foundation
, OpenGL
}:
let
  rpathLibs = [
    libGL
    libX11
    libXcursor
    libXi
    libXrandr
    libXxf86vm
    libxcb
  ] ++ lib.optionals stdenv.isLinux [
    libxkbcommon
    wayland
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "emulsion";
  version = "9.0";

  src = fetchFromGitHub {
    owner = "ArturKovacs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Cdi+PQDHxMQG7t7iwDi6UWfDwQjjA2yiOf9p/ahBlOw=";
  };

  cargoSha256 = "sha256-2wiLamnGqACx1r4WJbWPCN3tvhww/rRWz8fcvAbjYE0=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs = rpathLibs ++ lib.optionals stdenv.isDarwin [
    AppKit
    CoreGraphics
    CoreServices
    Foundation
    OpenGL
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/emulsion
  '';

  meta = with lib; {
    description = "A fast and minimalistic image viewer";
    homepage = "https://arturkovacs.github.io/emulsion-website/";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
