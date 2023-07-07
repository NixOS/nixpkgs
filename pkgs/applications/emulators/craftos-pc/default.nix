{ lib
, stdenv
, fetchFromGitHub
, callPackage
, patchelf
, unzip
, poco
, openssl
, SDL2
, SDL2_mixer
, ncurses
, libpng
, pngpp
, libwebp
}:

let
  version = "2.7.4";
  craftos2-lua = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2-lua";
    rev = "v${version}";
    sha256 = "sha256-JMBsSoO/yTLw7K1Ri3BzKr5bz5UirXiPr/Q0YoMumhY=";
  };
  craftos2-rom = fetchFromGitHub {
    owner = "McJack123";
    repo = "craftos2-rom";
    rev = "v${version}";
    sha256 = "sha256-BXTsBMlsymQHABWQCiv22Ia5jm2xv1jNy7Unwymtyp0=";
  };
in

stdenv.mkDerivation rec {
  pname = "craftos-pc";
  inherit version;

  src = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2";
    rev = "v${version}";
    sha256 = "sha256-9XMc7zmtPxlt3WgS93lUJNMFtUJ/llG9SFGtgdFqZEA=";
  };

  buildInputs = [ patchelf poco openssl SDL2 SDL2_mixer ncurses libpng pngpp libwebp ];

  preBuild = ''
    cp -R ${craftos2-lua}/* ./craftos2-lua/
    chmod -R u+w ./craftos2-lua
    make -C craftos2-lua linux
  '';

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/share/craftos $out/include
    DESTDIR=$out/bin make install
    cp ./craftos2-lua/src/liblua.so $out/lib
    patchelf --replace-needed craftos2-lua/src/liblua.so liblua.so $out/bin/craftos
    cp -R api $out/include/CraftOS-PC
    cp -R ${craftos2-rom}/* $out/share/craftos
  '';

  passthru.tests = {
    eval-hello-world = callPackage ./test-eval-hello-world { };
    eval-periphemu = callPackage ./test-eval-periphemu { };
  };

  meta = with lib; {
    description = "An implementation of the CraftOS-PC API written in C++ using SDL";
    homepage = "https://www.craftos-pc.cc";
    license = with licenses; [ mit free ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ siraben tomodachi94 ];
    mainProgram = "craftos";
  };
}
