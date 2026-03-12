{
  lib,
  mk64baserom ? null,
  requireFile,
  fetchFromGitHub,
  llvmPackages_19,
  cmake,
  copyDesktopItems,
  installShellFiles,
  makeWrapper,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  SDL2,
  gtk3,
  vulkan-loader,
  makeDesktopItem,
  n64recomp,
  directx-shader-compiler,
}:

let

  baseRom =
    if mk64baserom != null then
      mk64baserom
    else
      requireFile {
        name = "mk64.us.z64";
        message = ''
          mariokart64recomp only supports the US version of Mario Kart 64.
          Please dump your copy and rename it to mk64.us.z64
          and add it to the nix store using
          nix-store --add-fixed sha256 mk64.us.z64
          See https://dumping.guide/carts/nintendo/n64 for more details.
        '';
        hash = "sha256-1rhTjdY/ATLssoVufTKBbtPDDj5HmuzSPPg/troXpdo=";
      };

in

llvmPackages_19.stdenv.mkDerivation (finalAttrs: {
  pname = "mariokart64recomp";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "sonicdcer";
    repo = "MarioKart64Recomp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7h2dxa8yR5y03FGdoF9eLTv7ZQY7IkXPtkwu7Q+SbAo=";
    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
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
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL2
    gtk3
    vulkan-loader
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "MarioKart64Recompiled";
      icon = "MarioKart64Recompiled";
      exec = "MarioKart64Recompiled";
      comment = "Recompilation of MarioKart 64";
      desktopName = "MarioKart64Recompiled";
      categories = [ "Game" ];
    })
  ];

  preConfigure = ''
    ln -s ${baseRom} ./mk64.us.z64
    cp ${n64recomp}/bin/* .

    ./N64Recomp us.toml
    ./RSPRecomp aspMain.us.toml

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

    installBin MarioKart64Recompiled
    install -Dm644 -t $out/share ../recompcontrollerdb.txt
    install -Dm644 ../icons/512.png $out/share/icons/hicolor/512x512/apps/MarioKart64Recompiled.png
    install -Dm644 ../flatpak/io.github.mariokart64recomp.mariokart64recomp.desktop $out/share/applications/MarioKart64Recompiled.desktop
    cp -r ../assets $out/share/
    ln -s $out/share/recompcontrollerdb.txt $out/bin/recompcontrollerdb.txt
    ln -s $out/share/assets $out/bin/assets

    install -Dm644 -t $out/share/licenses/mariokart64recompiled ../COPYING
    install -Dm644 -t $out/share/licenses/mariokart64recompiled/N64ModernRuntime ../lib/N64ModernRuntime/COPYING
    install -Dm644 -t $out/share/licenses/mariokart64recompiled/RmlUi ../lib/RmlUi/LICENSE.txt
    install -Dm644 -t $out/share/licenses/mariokart64recompiled/lunasvg ../lib/lunasvg/LICENSE
    install -Dm644 -t $out/share/licenses/mariokart64recompiled/rt64 ../lib/rt64/LICENSE

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
       --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
     )
  '';

  # The game will segfault when not run from the same directory as the binary.
  postFixup = ''
    wrapProgram $out/bin/MarioKart64Recompiled --chdir "$out/bin/"
  '';

  meta = {
    description = "Recompilation of MarioKart 64";
    homepage = "https://github.com/sonicdcer/MarioKart64Recomp";
    license = with lib.licenses; [
      # MarioKart64Recompiled, N64ModernRuntime
      gpl3Only

      # RT64, RmlUi, lunasvg, sse2neon
      mit

      # reverse engineering
      unfree
    ];
    maintainers = with lib.maintainers; [ qubitnano ];
    mainProgram = "MarioKart64Recompiled";
    platforms = [ "x86_64-linux" ];
  };
})
