{ lib
, fetchFromGitHub
, rustPlatform
, cmake
, pkgconf
, freetype
, expat
, libX11
, libXcursor
, libXi
, libXrandr
, pop-launcher
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "onagre";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "oknozor";
    repo = "onagre";
    rev = version;
    hash = "sha256-FqmOcmq0yNxTXZRNPA5MpsTAm4cxXpvU99yPPhihayI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  cargoSha256 = "sha256-IOhAGrAiT2mnScNP7k7XK9CETUr6BjGdQVdEUvTYQT4=";

  nativeBuildInputs = [ cmake pkgconf makeWrapper ];
  buildInputs = [ freetype expat ];

  postInstall = ''
    wrapProgram $out/bin/onagre \
      --prefix LD_LIBRARY_PATH ":" ${lib.makeLibraryPath [ libX11 libXcursor libXi libXrandr ]} \
      --prefix PATH : ${pop-launcher}/bin
  '';

  meta = with lib; {
    description = "A general purpose application launcher for X and wayland inspired by rofi/wofi and alfred";
    homepage = "https://github.com/oknozor/onagre";
    license = licenses.mit;
    maintainers = [ maintainers.jfvillablanca ];
    platforms = platforms.linux;
    mainProgram = "onagre";
  };
}
