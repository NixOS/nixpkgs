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
, xdg_utils
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
  version = "7.2";

  src = fetchFromGitHub {
    owner = "ArturKovacs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1king04p5j4gsvprrfppwaxa5jn4ga4nc0v63wl6fvq2ngwnkg4g";
  };

  cargoSha256 = "19vb2q5w3063l7349p1b8q40n97a4hxdvc7h7qsx1iiwp75knbd0";

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

  installPhase = ''
    runHook preInstall
    install -D $releaseDir/emulsion $out/bin/emulsion
  '' + lib.optionalString stdenv.isLinux ''
      patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/emulsion
  '' + ''
    runHook postInstall
  '';

  dontPatchELF = true;

  meta = with lib; {
    description = "A fast and minimalistic image viewer";
    homepage = "https://arturkovacs.github.io/emulsion-website/";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
