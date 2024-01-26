{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "2.8";
  craftos2-lua = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2-lua";
    rev = "v${version}";
    hash = "sha256-xuNcWt3Wnh3WlYe6pB4dvP3PY9S5ghL9QQombGn8iyY=";
  };
  craftos2-rom = fetchFromGitHub {
    owner = "McJack123";
    repo = "craftos2-rom";
    rev = "v${version}";
    hash = "sha256-WZs/KIdpqLLzvpH2hiJpe/AehluoQMtewBbAb4htz8k=";
  };
in

stdenv.mkDerivation rec {
  pname = "craftos-pc";
  inherit version;

  src = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2";
    rev = "v${version}";
    hash = "sha256-nT/oN2XRU1Du1/IHlkRCzLqFwQ5s9Sr4FQs3ES+aPFs=";
  };

  patches = [
    ( # Fixes CCEmuX. This is a one-character change that did not make it into the release.
      fetchpatch {
        url = "https://github.com/MCJack123/craftos2/commit/9ef7e16b69ead69b5fe076724842a1e24b3de058.patch";
        hash = "sha256-SjNnsooDFt3JoVOO0xf6scrGXEQQmrQf91GY7VWaTOw=";
      }
    )
  ];

  buildInputs = [ patchelf poco openssl SDL2 SDL2_mixer ncurses libpng pngpp libwebp ];

  preBuild = ''
    cp -R ${craftos2-lua}/* ./craftos2-lua/
    chmod -R u+w ./craftos2-lua
    make -C craftos2-lua linux
  '';

  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
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
