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
  libx11,
  enableLuaJIT ? false,
}:

let
  version = "2.8.3";
  craftos2-rom = fetchFromGitHub {
    owner = "McJack123";
    repo = "craftos2-rom";
    rev = "v${version}";
    hash = "sha256-YidLt/JLwBMW0LMo5Q5PV6wGhF0J72FGX+iWYn6v0Z4=";
  };

  luaCtx =
    if enableLuaJIT then
      {
        pname = "craftos-pc-accelerated";
        binName = "craftos-luajit";
        luaDir = "craftos2-luajit";
        luaLib = "libluajit-craftos.so";
        luaSrc = fetchFromGitHub {
          owner = "MCJack123";
          repo = "craftos2-luajit";
          rev = "4f4466fd3fafd3523e2c07e91c478b73b6748f0c";
          hash = "sha256-YmecY6R2AHmk5S+RdfFtaXzLV9GksLdjTIGlrr+FpPo=";
        };
        craftosSrc = fetchFromGitHub {
          owner = "MCJack123";
          repo = "craftos2";
          rev = "v${version}-luajit";
          hash = "sha256-F7Y/9hlLL/r5R+oJtbIiQm8aZbKJqjl7AYrUum/+Aes=";
        };
      }
    else
      {
        pname = "craftos-pc";
        binName = "craftos";
        luaDir = "craftos2-lua";
        luaLib = "liblua${stdenv.hostPlatform.extensions.sharedLibrary}";
        luaSrc = fetchFromGitHub {
          owner = "MCJack123";
          repo = "craftos2-lua";
          rev = "v${version}";
          hash = "sha256-OCHN/ef83X4r5hZcPfFFvNJHjINCTiK+COf369/WPsA=";
        };
        craftosSrc = fetchFromGitHub {
          owner = "MCJack123";
          repo = "craftos2";
          rev = "v${version}";
          hash = "sha256-DbxAsXxpsa42dF6DaLmgIa+Hs/PPqJ4dE97PoKxG2Ig=";
        };
      };
in

stdenv.mkDerivation (finalAttrs: {
  pname = luaCtx.pname;
  inherit version;

  src = luaCtx.craftosSrc;

  nativeBuildInputs = [
    unzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    patchelf
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
  ];
  strictDeps = true;
  __structuredAttrs = true;

  preBuild = ''
    cp -R ${luaCtx.luaSrc}/* ./${luaCtx.luaDir}/
    chmod -R u+w ./${luaCtx.luaDir}
    make -C ${luaCtx.luaDir} ${
      lib.optionalString (!enableLuaJIT) (if stdenv.hostPlatform.isDarwin then "macosx" else "linux")
    }
  '';

  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  patches = [
    # fix includes of poco headers
    # https://github.com/MCJack123/craftos2/issues/391
    ./fix-poco-header-includes.patch
  ];

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/share/craftos $out/include
    DESTDIR=$out/bin make install
    cp ./${luaCtx.luaDir}/src/${luaCtx.luaLib} $out/lib
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      chmod +w $out/bin/${luaCtx.binName}
      install_name_tool -change ${luaCtx.luaLib} $out/lib/${luaCtx.luaLib} $out/bin/${luaCtx.binName}
    ''}
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --replace-needed ${luaCtx.luaDir}/src/${luaCtx.luaLib} ${luaCtx.luaLib} $out/bin/${luaCtx.binName}
    ''}
    cp -R api $out/include/CraftOS-PC
    cp -R ${craftos2-rom}/* $out/share/craftos

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p resources/linux-icons
      unzip resources/linux-icons.zip -d resources/linux-icons
      for dim in 16 24 32 48 64 96 128 256 1024; do
        dir="$out/share/icons/hicolor/$dimx$dim/apps"
        mkdir -p "$dir"
        cp "resources/linux-icons/$dim.png" "$dir/craftos.png"
      done

      mkdir -p $out/share/applications
      cp resources/linux-icons/CraftOS-PC.desktop $out/share/applications/CraftOS-PC.desktop
    ''}
  '';

  passthru.tests = {
    eval-hello-world = callPackage ./test-eval-hello-world {
      craftos-pc = finalAttrs.finalPackage;
    };
    eval-periphemu = callPackage ./test-eval-periphemu {
      craftos-pc = finalAttrs.finalPackage;
    };
  };

  meta = {
    description =
      "Implementation of the CraftOS-PC API written in C++ using SDL"
      + lib.optionalString enableLuaJIT " (LuaJIT-accelerated variant)";
    homepage = "https://www.craftos-pc.cc";
    license = with lib.licenses; [
      mit
      free
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      siraben
      tomodachi94
      viluon
    ];
    mainProgram = luaCtx.binName;
  };
})
