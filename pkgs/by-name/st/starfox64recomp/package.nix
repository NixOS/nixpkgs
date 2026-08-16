{
  lib,
  sf64baserom ? null,
  requireFile,
  fetchurl,
  fetchFromGitHub,
  fetchFromGitLab,
  llvmPackages_21,
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
    url = "https://gitlab.com/sonicdcer/sf64/-/raw/3c5d492d875c8a74f9657c86fb9c2480f4c4919f/tools/comptool.py";
    hash = "sha256-md56iEj6DKODKm3U0XrAygiaRlUgvFCSWfWyyh4lmzw=";
  };

  submodules = {
    "lib/RmlUi" = fetchFromGitHub {
      owner = "mikke89";
      repo = "RmlUi";
      rev = "7a06f27db04fe5d13a5dacc19b2b4544673a4eca";
      hash = "sha256-aBu97ZugJIfJTYFpgDYC/OU+pX/fe9ne4PsTG01mWIM=";
    };
    "lib/freetype-windows-binaries" = fetchFromGitHub {
      owner = "ubawurinna";
      repo = "freetype-windows-binaries";
      rev = "d6fb49d11a9d0011bf4ecfe7e570beaaa189838a";
      hash = "sha256-rk+D+bv84yCS9fBv3ZpMqgUwsAzz9wa/TiLoWyhI3f0=";
    };
    "lib/lunasvg" = fetchFromGitHub {
      owner = "sammycage";
      repo = "lunasvg";
      rev = "4166d0cccfc059b39d5ecfc372524375e59448f9";
      hash = "sha256-U/ohYe5j/c7bGvEFkEHZPggdzt6vu9ThnzVgECG8AWk=";
    };
    "lib/sse2neon" = fetchFromGitHub {
      owner = "DLTcollab";
      repo = "sse2neon";
      rev = "706d3b58025364c2371cafcf9b16e32ff7e630ed";
      hash = "sha256-jeaGP6j/ML6W+ls1ZKUQHWy4gXqkIrV3V918+YIDoXY=";
    };
    "lib/N64ModernRuntime" = fetchFromGitHub {
      owner = "N64Recomp";
      repo = "N64ModernRuntime";
      rev = "9ae9dbbe41cafcd6f425135c726aebe80777d682";
      hash = "sha256-SpDHUBcnTR0gg+qmffX3fdUn8KvN4pEwoZXdfvuuZlI=";
      fetchSubmodules = true;
    };
    "lib/rt64" = fetchFromGitHub {
      owner = "rt64";
      repo = "rt64";
      rev = "aa047b8158034552466175b8e8554988caa18976";
      hash = "sha256-Jc47Hr4R3GLCPXzPR7Z7T+MMi0aaZcF3kK1FmjA6cl0=";
      fetchSubmodules = true;
    };
    "lib/sf64decomp" = fetchFromGitLab {
      owner = "sonicdcer";
      repo = "sf64";
      rev = "b870a09cf33e882463dfecedaf917a9505b79cec";
      hash = "sha256-VJjGPNgPWP6McMxAM9P6Nt0H9CY5mQheD7lsq7e9igE=";
    };
    "Starfox64RecompSyms" = fetchFromGitLab {
      owner = "sonicdcer";
      repo = "Starfox64RecompSyms";
      rev = "156aa2e840e79be04e752774cbc8d09d6f44d7a8";
      hash = "sha256-NK1UOjz5DED9TYMWjxxz8MrFY9EHEvTchfXzwv0xVpk=";
    };
  };

in

llvmPackages_21.stdenv.mkDerivation (finalAttrs: {
  pname = "starfox64recomp";
  version = "1.0.3";

  src = fetchFromGitLab {
    owner = "sonicdcer";
    repo = "Starfox64Recomp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fOc64p5WZ98rxW/KWk1dYs3aqRxqBkFP66m7z07P3oQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    installShellFiles
    llvmPackages_21.lld
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

  postUnpack = lib.concatLines (
    lib.mapAttrsToList (path: drv: ''
      mkdir -p "$sourceRoot/${path}"
      cp -r ${drv}/. "$sourceRoot/${path}/"
    '') submodules
  );

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
