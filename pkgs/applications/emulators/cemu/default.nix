{ lib, stdenv, fetchFromGitHub
, addOpenGLRunpath
, wrapGAppsHook
, cmake
, glslang
, nasm
, pkg-config

, SDL2
, boost
, cubeb
, curl
, fmt_9
, glm
, gtk3
, hidapi
, imgui
, libpng
, libzip
, libXrender
, pugixml
, rapidjson
, vulkan-headers
, wayland
, wxGTK32
, zarchive
, gamemode
, vulkan-loader

, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "cemu";
  version = "2.0-47";

  src = fetchFromGitHub {
    owner = "cemu-project";
    repo = "Cemu";
    rev = "v${version}";
    hash = "sha256-0N/bJJHWMHF+ZlVxNHV8t/1jFr3ER3GNF8CPAHVSsak=";
  };

  patches = [
    # glslangTargets want SPIRV-Tools-opt to be defined:
    # > The following imported targets are referenced, but are missing:
    # > SPIRV-Tools-opt
    ./cmakelists.patch
  ];

  nativeBuildInputs = [
    addOpenGLRunpath
    wrapGAppsHook
    cmake
    glslang
    nasm
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
    imgui
    libpng
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
    "-DCMAKE_C_FLAGS_RELEASE=-DNDEBUG"
    "-DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG"
    "-DENABLE_VCPKG=OFF"
    "-DENABLE_FERAL_GAMEMODE=ON"

    # PORTABLE:
    # "All data created and maintained by Cemu will be in the directory where the executable file is located"
    "-DPORTABLE=OFF"
  ];

  preConfigure = with lib; let
    tag = last (splitString "-" version);
  in ''
    rm -rf dependencies/imgui
    ln -s ${imgui}/include/imgui dependencies/imgui
    substituteInPlace src/Common/version.h --replace " (experimental)" "-${tag} (experimental)"
    substituteInPlace dependencies/gamemode/lib/gamemode_client.h --replace "libgamemode.so.0" "${gamemode.lib}/lib/libgamemode.so.0"
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Cemu is a Wii U emulator";
    homepage = "https://cemu.info";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zhaofengli baduhai ];
    mainProgram = "cemu";
  };
}
