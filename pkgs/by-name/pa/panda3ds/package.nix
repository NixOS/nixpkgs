{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,

  xorg,
  kdePackages,
  cmake,
  pkg-config,
  imagemagick,

  # Build the Emulator with Qt GUI
  # Disable to compile with the SDL2 frontend instead
  withQt ? false,

  # (vulkan is currently experimental with qtgui and will cause a segfault, so don't even bother trying to compile it)
  # (metal is not supported on qt gui at all, it always uses context_agl)
  # (opengl is *always* required for the qt gui, even to just build it)
  withVulkan ? stdenv.hostPlatform.isLinux && !withQt,
  withMetal ? stdenv.hostPlatform.isDarwin && !withQt,
  withOpenGL ? stdenv.hostPlatform.isLinux || withQt,

  # Enable Lua (LuaJIT) scripting support
  withLuaJIT ? true,

  # Enable Discord RPC support
  withDiscordRPC ? true,

  # Enable RenderDoc API support
  withRenderdoc ? false,

  # Enable tests
  # enableTests ? true,

  SDL2,
  libGL,
  vulkan-headers,
  vulkan-loader,
  glslang,
  wayland,
  # misc. rt dep:
  pulseaudio,

  # msc. de-vendored deps
  boost,
  discord-rpc,
  fdk_aac,
  luajit,
  libuv,
  fmt,

  # test framework
  # catch2,
}:
stdenv.mkDerivation {
  pname = "panda3ds";
  version = "0.8.0-unstable-2024-11-12";

  src = fetchFromGitHub {
    owner = "wheremyfoodat";
    repo = "panda3ds";
    rev = "b85dba277fb777b095623a24cd924d0725e1596b";
    hash = "sha256-zKpz7c3frSzHbIKnTB88y9GJOqW31xQdgUDjoAdDTi8=";
    fetchSubmodules = true;
  };

  patches = [
    ./no-vendor.patch # de-vendor some dependencies
    ./config-file-path.patch # move config file to the app data root
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    imagemagick
  ] ++ (if withQt then [ kdePackages.wrapQtAppsHook ] else [ makeWrapper ]);

  buildInputs =
    [
      SDL2
      fdk_aac
      boost
      fmt
    ]
    ++ lib.optionals withQt [
      kdePackages.qtbase
      # kdePackages.qtwayland # (broken)
    ]
    ++ lib.optionals withLuaJIT [
      luajit
      libuv
    ]
    ++ lib.optionals withDiscordRPC [
      discord-rpc
    ]
    ++ lib.optionals withVulkan [
      vulkan-headers
      vulkan-loader
      glslang
    ]
    ++ lib.optionals withOpenGL [
      libGL
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      xorg.libX11
      wayland # required by context_egl_wayland
    ];
  # ++ lib.optionals enableTests [
  #   catch2
  # ];

  # delete unused vendored third_party deps
  postUnpack = ''
    rm -r /build/source/third_party/{SDL2,discord-rpc,fdk-aac,LuaJIT,boost,Catch2,fmt}
  '';

  # fix missing ir/var/empty/constant_propagation_pass.cpp
  postPatch = ''
    mkdir -p third_party/dynarmic/src/dynarmic/ir/var
    ln -s ../opt third_party/dynarmic/src/dynarmic/ir/var/empty
  '';

  installPhase = ''
    runHook preInstall

    # main binary
    install -Dm755 /build/source/build/Alber $out/bin/Alber

    # desktop file
    install -Dm444 $src/.github/Alber.desktop $out/share/applications/Alber.desktop

    # icons
    for size in 16 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick convert \
        -resize "$size"x"$size" \
        $src/docs/img/Alber.png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/Alber.png
    done

    runHook postInstall
  '';

  postInstall =
    let
      libs = lib.makeLibraryPath (
        lib.optionals withOpenGL [ libGL ]
        ++ lib.optionals withVulkan [ vulkan-loader ]
        ++ lib.optionals withDiscordRPC [ discord-rpc ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [ pulseaudio ]
      );
    in
    if withQt then
      ''
        qtWrapperArgs+=(
          --prefix LD_LIBRARY_PATH : ${libs}
          --set QT_QPA_PLATFORM "xcb" # force x11, wayland segfaults
        )
      ''
    else
      ''
        wrapProgram "$out/bin/Alber" \
          --prefix LD_LIBRARY_PATH : ${libs}
      '';

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_USER_BUILD" true)
    (lib.cmakeBool "DISABLE_PANIC_DEV" true)
    (lib.cmakeBool "ENABLE_RENDERDOC_API" withRenderdoc)
    (lib.cmakeBool "ENABLE_METAL" withMetal)
    (lib.cmakeBool "ENABLE_VULKAN" withVulkan)
    (lib.cmakeBool "ENABLE_OPENGL" withOpenGL)
    (lib.cmakeBool "ENABLE_LUAJIT" withLuaJIT)
    (lib.cmakeBool "ENABLE_DISCORD_RPC" withDiscordRPC)
    (lib.cmakeBool "ENABLE_QT_GUI" withQt)
    (lib.cmakeBool "DISABLE_SSE4" (!stdenv.hostPlatform.sse4_1Support))
    (lib.cmakeBool "ENABLE_LTO" true)
    (lib.cmakeBool "USE_SYSTEM_SDL2" true)
    (lib.cmakeBool "ENABLE_TESTS" false) # tests are broken
  ];

  meta = {
    description = "HLE 3DS emulator" + lib.optionalString withQt " (Qt GUI)";
    longDescription = ''
      Panda3DS is an HLE, red-panda-themed Nintendo 3DS emulator written in C++ which started out as a fun project out
       of curiosity, but evolved into something that can sort of play games!
    '';
    homepage = "https://panda3ds.com/";
    changelog = "https://github.com/wheremyfoodat/Panda3DS/releases";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ griffi-gh ];
    mainProgram = "Alber";
    platforms = with lib.platforms; linux ++ darwin;
    broken =
      stdenv.hostPlatform.isDarwin # darwin needs more work (and i dont have a mac to test on)
      || (withQt && !withOpenGL); # qt gui requires opengl (won't even build without -DENABLE_OPENGL=ON)
  };
}
