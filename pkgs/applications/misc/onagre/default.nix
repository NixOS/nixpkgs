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
  version = "1.0.0-alpha.0";

  src = fetchFromGitHub {
    owner = "oknozor";
    repo = pname;
    rev = version;
    hash = "sha256-hP+slfCWgsTgR2ZUjAmqx9f7+DBu3MpSLvaiZhqNK1Q=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pop-launcher-1.2.1" = "sha256-LeKaJIvooD2aUlY113P0mzxOcj63sGkrA0SIccNqCLY=";
    };
  };

  cargoSha256 = "sha256-IOhAGrAiT2mnScNP7k7XK9CETUr6BjGdQVdEUvTYQT4=";

  nativeBuildInputs = [ cmake pkgconf makeWrapper ];
  buildInputs = [ freetype expat ];

  postInstall = ''
    wrapProgram $out/bin/onagre \
      --prefix LD_LIBRARY_PATH ":" ${lib.makeLibraryPath [ libX11 libXcursor libXi libXrandr ]} \
      --prefix PATH ":" ${lib.getExe pop-launcher}
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
