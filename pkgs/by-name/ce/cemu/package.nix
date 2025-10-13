{
  lib,
  SDL2,
  addDriverRunpath,
  boost,
  cmake,
  cubeb,
  curl,
  fetchFromGitHub,
  fetchpatch2,
  fmt_9,
  gamemode,
  glm,
  glslang,
  gtk3,
  hidapi,
  imgui,
  libXrender,
  libpng,
  libusb1,
  libzip,
  nasm,
  ninja,
  nix-update-script,
  pkg-config,
  pugixml,
  rapidjson,
  stdenv,
  testers,
  vulkan-headers,
  vulkan-loader,
  wayland,
  wayland-scanner,
  wrapGAppsHook3,
  wxGTK32,
  zarchive,
  bluez,
}:

let
  # cemu doesn't build with imgui 1.91.4 or newer:
  # before v1.91.4 (2024/10/08) the default type for ImTextureID was void*.
  imgui' = imgui.overrideAttrs rec {
    version = "1.91.3";
    src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      tag = "v${version}";
      hash = "sha256-J4gz4rnydu8JlzqNC/OIoVoRcgeFd6B1Qboxu5drOKY=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cemu";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "cemu-project";
    repo = "Cemu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YO3rMhlBZ5fGu0ceAFB0R3owFuSobx39faWL9EUFwAM=";
  };

  patches = [
    # glslangTargets want SPIRV-Tools-opt to be defined:
    # > The following imported targets are referenced, but are missing:
    # > SPIRV-Tools-opt
    ./0000-spirv-tools-opt-cmakelists.patch
    ./0002-cemu-imgui.patch
    (fetchpatch2 {
      url = "https://github.com/cemu-project/Cemu/commit/c1c2962b6633017cd956c6925288e2529c532ee4.diff?full_index=1";
      hash = "sha256-Dz7WnCf5+Vbr/ETX71wIo/x/zPWdrsOtPH7bsL5Bd+A=";
    })
  ];

  nativeBuildInputs = [
    SDL2
    addDriverRunpath
    wrapGAppsHook3
    cmake
    nasm
    ninja
    pkg-config
    wxGTK32
    wayland-scanner
  ];

  buildInputs = [
    SDL2
    boost
    cubeb
    curl
    fmt_9
    glm
    glslang
    gtk3
    hidapi
    imgui'
    libpng
    libusb1
    libzip
    libXrender
    pugixml
    rapidjson
    vulkan-headers
    wayland
    wxGTK32
    zarchive
    bluez
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_C_FLAGS_RELEASE" "-DNDEBUG")
    (lib.cmakeFeature "CMAKE_CXX_FLAGS_RELEASE" "-DNDEBUG")
    (lib.cmakeBool "ENABLE_VCPKG" false)
    (lib.cmakeBool "ENABLE_FERAL_GAMEMODE" true)

    # PORTABLE: "All data created and maintained by Cemu will be in
    # the directory where the executable file is located"
    (lib.cmakeBool "PORTABLE" false)
  ];

  strictDeps = true;

  preConfigure =
    let
      tag = lib.splitString "." (lib.last (lib.splitString "-" finalAttrs.version));
      majorv = builtins.elemAt tag 0;
      minorv = builtins.elemAt tag 1;
    in
    ''
      rm -rf dependencies/imgui
      # cemu expects imgui source code, not just header files
      ln -s ${imgui'.src} dependencies/imgui
      substituteInPlace CMakeLists.txt --replace-fail "EMULATOR_VERSION_MAJOR \"0\"" "EMULATOR_VERSION_MAJOR \"${majorv}\""
      substituteInPlace CMakeLists.txt --replace-fail "EMULATOR_VERSION_MINOR \"0\"" "EMULATOR_VERSION_MINOR \"${minorv}\""
      substituteInPlace dependencies/gamemode/lib/gamemode_client.h --replace-fail "libgamemode.so.0" "${gamemode.lib}/lib/libgamemode.so.0"
    '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ../bin/Cemu_release $out/bin/Cemu
    ln -s $out/bin/Cemu $out/bin/cemu

    mkdir -p $out/share/applications
    substitute ../dist/linux/info.cemu.Cemu.desktop $out/share/applications/info.cemu.Cemu.desktop \
      --replace "Exec=Cemu" "Exec=$out/bin/Cemu"

    install -Dm644 ../dist/linux/info.cemu.Cemu.metainfo.xml -t $out/share/metainfo
    install -Dm644 ../src/resource/logo_icon.png $out/share/icons/hicolor/128x128/apps/info.cemu.Cemu.png

    runHook postInstall
  '';

  preFixup =
    let
      libs = [ vulkan-loader ];
    in
    ''
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libs}"
      )
    '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    description = "Software to emulate Wii U games and applications on PC";
    homepage = "https://cemu.info";
    license = lib.licenses.mpl20;
    mainProgram = "cemu";
    maintainers = with lib.maintainers; [
      zhaofengli
      baduhai
    ];
    platforms = [ "x86_64-linux" ];
  };
})
