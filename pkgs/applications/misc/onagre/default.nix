{ lib
, fetchFromGitHub
, makeWrapper
, rustPlatform
, cmake
, pkgconf
, freetype
, expat
, wayland
, xorg
, libxkbcommon
, pop-launcher
}:

rustPlatform.buildRustPackage rec {
  pname = "onagre";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "onagre-launcher";
    repo = pname;
    rev = version;
    hash = "sha256-FqmOcmq0yNxTXZRNPA5MpsTAm4cxXpvU99yPPhihayI=";
  };

  cargoSha256 = "sha256-xC5nf7DJCMBR2gUoB5NWZJGuZ8brs8WklCzg/osCsho=";

  nativeBuildInputs = [ makeWrapper cmake pkgconf ];
  buildInputs = [ freetype expat wayland libxkbcommon xorg.libX11 xorg.libXcursor xorg.libXrandr xorg.libXi ];

  postFixup = let
    rpath = lib.makeLibraryPath buildInputs;
  in ''
    patchelf --set-rpath ${rpath} $out/bin/onagre
    wrapProgram $out/bin/onagre \
      --prefix PATH ':' ${lib.makeBinPath [
        pop-launcher
      ]}
  '';

  meta = with lib; {
    description = "A general purpose application launcher for X and wayland inspired by rofi/wofi and alfred";
    homepage = "https://github.com/onagre-launcher/onagre";
    license = licenses.mit;
    maintainers = [ maintainers.jfvillablanca ];
    platforms = platforms.linux;
    mainProgram = "onagre";
  };
}
