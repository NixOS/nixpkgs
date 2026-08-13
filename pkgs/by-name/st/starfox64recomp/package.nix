{
  lib,
  sf64baserom ? null,
  requireFile,
  fetchurl,
  fetchFromGitHub,
  llvmPackages_19,
  cmake,
  copyDesktopItems,
  installShellFiles,
  makeWrapper,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook3,
  SDL2,
  gtk3,
  vulkan-loader,
  makeDesktopItem,
  n64recomp,
  sm64tools,
  directx-shader-compiler,
}:

let

  baseRom =
    if sf64baserom != null then
      sf64baserom
    else
      requireFile {
        name = "starfox64.us.rev1.z64";
        message = ''
          starfox64recomp only supports the US version 1.1 of Starfox 64.
          Please dump your copy and rename it to starfox64.us.rev1.z64
          and add it to the nix store using
          nix-store --add-fixed sha256 starfox64.us.rev1.z64
          See https://dumping.guide/carts/nintendo/n64 for more details.
        '';
        hash = "sha256-OFvPGQHtEvsRUvPCJ9GWjMVK5B6FZtpmaV33GvQKVz8=";
      };

  comptool = fetchurl {
    name = "comptool.py";
    url = "https://raw.githubusercontent.com/sonicdcer/sf64/83eeee7d96fbe5a6b6fa013e13ed7eda8213b3e3/tools/comptool.py";
    hash = "sha256-md56iEj6DKODKm3U0XrAygiaRlUgvFCSWfWyyh4lmzw=";
  };

in

llvmPackages_19.stdenv.mkDerivation (finalAttrs: {
  pname = "starfox64recomp";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "sonicdcer";
    repo = "Starfox64Recomp";
    tag = finalAttrs.version;
    hash = "sha256-JhrVF7YjDrZcmL+7S8g/g5SQ3WcxnM9LJryT0Ss3uMw=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    installShellFiles
    llvmPackages_19.lld
    makeWrapper
    ninja
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL2
    gtk3
    vulkan-loader
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Starfox64Recompiled";
      icon = "Starfox64Recompiled";
      exec = "Starfox64Recompiled";
      comment = "Recompilation of Starfox 64";
      desktopName = "Starfox64Recompiled";
      categories = [ "Game" ];
    })
  ];

  preConfigure = ''
    ln -s ${baseRom} ./starfox64.us.rev1.z64
    cp ${n64recomp}/bin/* .
    ln -s ${sm64tools}/bin/mio0 .
    ln -s ${comptool} comptool.py

    python3 ./comptool.py -dse baserom starfox64.us.rev1.z64 starfox64.us.rev1.uncompressed.z64

    ./N64Recomp us.rev1.toml
    ./RSPRecomp aspMain.us.rev1.toml

    substituteInPlace lib/rt64/CMakeLists.txt \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/src/contrib/dxc/lib/x64" "${directx-shader-compiler}/lib/" \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/src/contrib/dxc/bin/x64/dxc-linux" "${directx-shader-compiler}/bin/dxc" \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/src/contrib/dxc/inc" "${directx-shader-compiler.src}/include/dxc"

    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/lib/rt64/src/contrib/dxc/lib/x64" "${directx-shader-compiler}/lib/" \
      --replace-fail "\''${PROJECT_SOURCE_DIR}/lib/rt64/src/contrib/dxc/bin/x64/dxc-linux" "${directx-shader-compiler}/bin/dxc"
  '';

  # This is required or else nothing will build
  hardeningDisable = [
    "format"
    "pic"
    "stackprotector"
    "zerocallusedregs"
  ];

  installPhase = ''
    runHook preInstall

    installBin Starfox64Recompiled
    install -Dm644 -t $out/share ../recompcontrollerdb.txt
    install -Dm644 ../icons/512.png $out/share/icons/hicolor/512x512/apps/Starfox64Recompiled.png
    cp -r ../assets $out/share/
    ln -s $out/share/recompcontrollerdb.txt $out/bin/recompcontrollerdb.txt
    ln -s $out/share/assets $out/bin/assets

    install -Dm644 -t $out/share/licenses/starfox64recompiled/N64ModernRuntime ../lib/N64ModernRuntime/COPYING
    install -Dm644 -t $out/share/licenses/starfox64recompiled/RmlUi ../lib/RmlUi/LICENSE.txt
    install -Dm644 -t $out/share/licenses/starfox64recompiled/lunasvg ../lib/lunasvg/LICENSE
    install -Dm644 -t $out/share/licenses/starfox64recompiled/rt64 ../lib/rt64/LICENSE

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
       --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
     )
  '';

  # The game will segfault when not run from the same directory as the binary.
  postFixup = ''
    wrapProgram $out/bin/Starfox64Recompiled --chdir "$out/bin/"
  '';

  meta = {
    description = "Static recompilation of Starfox 64 for PC (Windows/Linux)";
    homepage = "https://github.com/sonicdcer/Starfox64Recomp";
    license = with lib.licenses; [

      # Starfox64Recompiled
      gpl3Plus

      # N64ModernRuntime
      gpl3Only

      # RT64, RmlUi, lunasvg, sse2neon
      mit

      # reverse engineering
      unfree
    ];
    maintainers = with lib.maintainers; [ qubitnano ];
    mainProgram = "Starfox64Recompiled";
    platforms = [ "x86_64-linux" ];
  };
})
