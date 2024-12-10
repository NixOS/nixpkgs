{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  patchelf,
  unzip,
  poco,
  openssl,
  SDL2,
  SDL2_mixer,
  ncurses,
  libpng,
  pngpp,
  libwebp,
}:

let
  version = "2.8.3";
  craftos2-lua = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2-lua";
    rev = "v${version}";
    hash = "sha256-OCHN/ef83X4r5hZcPfFFvNJHjINCTiK+COf369/WPsA=";
  };
  craftos2-rom = fetchFromGitHub {
    owner = "McJack123";
    repo = "craftos2-rom";
    rev = "v${version}";
    hash = "sha256-YidLt/JLwBMW0LMo5Q5PV6wGhF0J72FGX+iWYn6v0Z4=";
  };
in

stdenv.mkDerivation rec {
  pname = "craftos-pc";
  inherit version;

  src = fetchFromGitHub {
    owner = "MCJack123";
    repo = "craftos2";
    rev = "v${version}";
    hash = "sha256-DbxAsXxpsa42dF6DaLmgIa+Hs/PPqJ4dE97PoKxG2Ig=";
  };

  nativeBuildInputs = [
    patchelf
    unzip
  ];
  buildInputs = [
    poco
    openssl
    SDL2
    SDL2_mixer
    ncurses
    libpng
    pngpp
    libwebp
  ];
  strictDeps = true;

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

    mkdir -p resources/linux-icons
    unzip resources/linux-icons.zip -d resources/linux-icons
    for dim in 16 24 32 48 64 96 128 256 1024; do
      dir="$out/share/icons/hicolor/$dimx$dim/apps"
      mkdir -p "$dir"
      cp "resources/linux-icons/$dim.png" "$dir/craftos.png"
    done

    mkdir -p $out/share/applications
    cp resources/linux-icons/CraftOS-PC.desktop $out/share/applications/CraftOS-PC.desktop
  '';

  passthru.tests = {
    eval-hello-world = callPackage ./test-eval-hello-world { };
    eval-periphemu = callPackage ./test-eval-periphemu { };
  };

  meta = with lib; {
    description = "An implementation of the CraftOS-PC API written in C++ using SDL";
    homepage = "https://www.craftos-pc.cc";
    license = with licenses; [
      mit
      free
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [
      siraben
      tomodachi94
    ];
    mainProgram = "craftos";
  };
}
