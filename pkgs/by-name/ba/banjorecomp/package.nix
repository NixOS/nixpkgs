{
  lib,
  banjobaserom ? null,
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
  bk_rom_compressor,
}:

let

  baseRom =
    if banjobaserom != null then
      banjobaserom
    else
      requireFile {
        name = "baserom.us.v10.z64";
        message = ''
          banjorecomp only supports the US 1.0 version of Banjo-Kazooie.
          Please dump your copy and rename it to baserom.us.v10.z64
          and add it to the nix store using
          nix-store --add-fixed sha256 baserom.us.v10.z64
          See https://dumping.guide/carts/nintendo/n64 for more details.
        '';
        hash = "sha256-WYdYNbmlEouwBUMVp/kp4gccIAHlKNcL9UPh1mgObv8=";
      };

in

llvmPackages_19.stdenv.mkDerivation (finalAttrs: {
  pname = "banjorecomp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "BanjoRecomp";
    repo = "BanjoRecomp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ANDoYrzFG0xw8c8TcJqExEDOHkjsA9hGT+D/dd2UnvU=";
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
      name = "BanjoRecompiled";
      icon = "BanjoRecompiled";
      exec = "BanjoRecompiled";
      comment = "Recompilation of Banjo-Kazooie";
      desktopName = "BanjoRecompiled";
      categories = [ "Game" ];
    })
  ];

  preConfigure = ''
    ln -s ${baseRom} ./baserom.us.v10.z64
    cp ${n64recomp}/bin/* .
    cp ${bk_rom_compressor}/bin/* .

    ./bk_rom_decompress baserom.us.v10.z64 banjo.us.v10.decompressed.z64

    ./N64Recomp banjo.us.rev0.toml
    ./RSPRecomp n_aspMain.us.rev0.toml

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

    installBin BanjoRecompiled
    install -Dm644 -t $out/share ../recompcontrollerdb.txt
    install -Dm644 ../icons/app.png $out/share/icons/hicolor/512x512/apps/BanjoRecompiled.png
    cp -r ../assets $out/share/
    ln -s $out/share/recompcontrollerdb.txt $out/bin/recompcontrollerdb.txt
    ln -s $out/share/assets $out/bin/assets

    install -Dm644 -t $out/share/licenses/banjorecomp ../COPYING
    install -Dm644 -t $out/share/licenses/banjorecomp/N64ModernRuntime ../lib/N64ModernRuntime/COPYING
    install -Dm644 -t $out/share/licenses/banjorecomp/rt64 ../lib/rt64/LICENSE

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
       --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
     )
  '';

  # The game will segfault when not run from the same directory as the binary.
  postFixup = ''
    wrapProgram $out/bin/BanjoRecompiled --chdir "$out/bin/"
  '';

  meta = {
    description = "PC Port of Banjo-Kazooie made using N64: Recompiled";
    homepage = "https://github.com/BanjoRecomp/BanjoRecomp";
    license = with lib.licenses; [
      # BanjoRecompiled, N64ModernRuntime
      gpl3Only

      # RT64
      mit

      # reverse engineering
      unfree
    ];
    maintainers = with lib.maintainers; [ qubitnano ];
    mainProgram = "BanjoRecompiled";
    platforms = [ "x86_64-linux" ];
  };
})
