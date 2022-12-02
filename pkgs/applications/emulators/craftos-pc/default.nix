{ lib
, stdenv
, fetchFromGitHub
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
  craftos2-lua = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2-lua";
    rev = "v2.6.6";
    sha256 = "cCXH1GTRqJQ57/6sWIxik366YBx/ii3nzQwx4YpEh1w=";
  };
  craftos2-rom = fetchFromGitHub {
    owner = "McJack123";
    repo = "craftos2-rom";
    rev = "v2.6.6";
    sha256 = "VzIqvf83k121DxuH5zgZfFS9smipDonyqqhVgj2kgYw=";
  };
in

stdenv.mkDerivation rec {
  pname = "craftos-pc";
  version = "2.6.6";

  src = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2";
    rev = "v${version}";
    sha256 = "9lpAWYFli3/OBfmu2dQxKi+/TaHaBQNpZsCURvl0h/E=";
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

  meta = with lib; {
    description = "An implementation of the CraftOS-PC API written in C++ using SDL";
    homepage = "https://www.craftos-pc.cc";
    license = with licenses; [ mit free ];
    platforms = platforms.linux;
    maintainers = [ maintainers.siraben ];
    mainProgram = "craftos";
  };
}
