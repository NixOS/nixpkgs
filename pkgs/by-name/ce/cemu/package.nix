{
  lib,
  SDL2,
  addOpenGLRunpath,
  boost,
  cmake,
  cubeb,
  curl,
  fetchFromGitHub,
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
  wrapGAppsHook3,
  wxGTK32,
  zarchive,
}:

let
  # cemu doesn't build with imgui 1.90.2 or newer:
  # error: 'struct ImGuiIO' has no member named 'ImeWindowHandle'
  imgui' = imgui.overrideAttrs rec {
    version = "1.90.1";
    src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      rev = "v${version}";
      sha256 = "sha256-gf47uLeNiXQic43buB5ZnMqiotlUfIyAsP+3H7yJuFg=";
    };
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "cemu";
  version = "2.0-86";

  src = fetchFromGitHub {
    owner = "cemu-project";
    repo = "Cemu";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AS5Qo4J0U1MeTYWl4jiJMi879bhBuioU1BikxGKtUrE=";
  };

  patches = [
    # glslangTargets want SPIRV-Tools-opt to be defined:
    # > The following imported targets are referenced, but are missing:
    # > SPIRV-Tools-opt
    ./0000-spirv-tools-opt-cmakelists.patch
  ];

  nativeBuildInputs = [
    SDL2
    addOpenGLRunpath
    wrapGAppsHook3
    cmake
    glslang
    nasm
    ninja
    pkg-config
  ];

  buildInputs = [
    SDL2
    boost
    cubeb
    curl
    fmt_9
    glm
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

  preConfigure = let
    tag = lib.last (lib.splitString "-" finalAttrs.version);
  in ''
    rm -rf dependencies/imgui
    # cemu expects imgui source code, not just header files
    ln -s ${imgui'.src} dependencies/imgui
    substituteInPlace src/Common/version.h --replace-fail " (experimental)" "-${tag} (experimental)"
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

  preFixup = let
    libs = [ vulkan-loader ] ++ cubeb.passthru.backendLibs;
  in ''
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
    maintainers = with lib.maintainers; [ zhaofengli baduhai AndersonTorres ];
    platforms = [ "x86_64-linux" ];
  };
})
