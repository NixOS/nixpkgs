{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  xmake,
  gnumake,
  lua5_1,
  go,
  rustc,
  cargo,
  makeWrapper,
  openssl,
  dbus,
  libGL,
  libx11,
  libxext,
  libxcb,
  alsa-lib,
  libpulseaudio,
  systemdLibs,
  zlib,
  rustPlatform,
  writableTmpDirAsHomeHook,
}:

let
  hostArch =
    if stdenv.hostPlatform.isx86_64 then
      "x86_64"
    else if stdenv.hostPlatform.isAarch64 then
      "aarch64"
    else
      throw "dora-ssr: unsupported host architecture";

  bgfxArch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x86_64";
  waGoArch = if stdenv.hostPlatform.isAarch64 then "arm64" else "amd64";
  waLibArch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "amd64";
  rustTarget = stdenv.hostPlatform.rust.rustcTargetSpec;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dora-ssr";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "IppClub";
    repo = "Dora-SSR";
    rev = "v${finalAttrs.version}";
    hash = "sha256-b9M/OZmDeEOpMdJWSLwmk1bO1fhHYy/5ypKf/Jxb4YQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-uBCttYQX6A3OcW60LO1c9WpWukAAq4/HgKR/n12gnTg=";
  };

  cargoRoot = "Source/Rust";

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    xmake
    gnumake
    lua5_1
    lua5_1.pkgs.luafilesystem
    go
    rustc
    cargo
    rustPlatform.cargoSetupHook
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    openssl
    dbus
    libGL
    libx11
    libxext
    libxcb
    alsa-lib
    libpulseaudio
    systemdLibs
    zlib
  ];

  # Dora depends on its SDL2 fork, customized bgfx build, curated Love subset,
  # and portable decoder-only Theora integration. The corresponding nixpkgs
  # packages are not drop-in replacements for these bundled components.
  buildPhase = ''
    runHook preBuild

    HOST_ARCH="${hostArch}"
    BGFX_ARCH="${bgfxArch}"
    WA_GO_ARCH="${waGoArch}"
    WA_LIB_ARCH="${waLibArch}"
    RUST_TARGET="${rustTarget}"

    echo "=== [1/6] SDL2 ==="
    cd Source/3rdParty/SDL2
    cmake -S . -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DSDL_CMAKE_DEBUG_POSTFIX= \
      -DSDL_SHARED=OFF -DSDL_STATIC=ON -DSDL_STATIC_PIC=ON \
      -DSDL_PIPEWIRE=OFF -DSDL_TEST=OFF -DSDL_TESTS=OFF \
      -DSDL2_DISABLE_INSTALL=ON
    cmake --build build --target SDL2-static --parallel $NIX_BUILD_CORES
    mkdir -p Lib/Linux/"$HOST_ARCH"
    cp build/libSDL2.a Lib/Linux/"$HOST_ARCH"/
    cd ../../..

    echo "=== [2/6] bgfx ==="
    cd Source/3rdParty/bgfx
    xmake f -p linux -a "$BGFX_ARCH" -m release -y
    xmake build -j "$NIX_BUILD_CORES"
    cd ../../..

    echo "=== [3/6] Love ==="
    cd Source/3rdParty/Love
    xmake f -p linux -a "$BGFX_ARCH" -m release -y
    xmake build -j "$NIX_BUILD_CORES" love
    mkdir -p Artifacts/Linux/"$HOST_ARCH"
    cp build/linux/"$BGFX_ARCH"/release/liblove.a Artifacts/Linux/"$HOST_ARCH"/
    cd ../../..

    echo "=== [4/6] Theora ==="
    cd Source/3rdParty/theora
    xmake f -p linux -a "$BGFX_ARCH" -m release -y
    xmake build -j "$NIX_BUILD_CORES" theoradec
    mkdir -p Lib/Linux/"$HOST_ARCH"
    cp build/linux/"$BGFX_ARCH"/release/libtheoradec.a Lib/Linux/"$HOST_ARCH"/
    cd ../../..

    echo "=== [5/6] Wa ==="
    cd Source/3rdParty/Wa/Source
    mkdir -p ../Lib/Linux/"$WA_LIB_ARCH"
    GOOS=linux GOARCH="$WA_GO_ARCH" CGO_ENABLED=1 GOFLAGS="-mod=vendor" \
      go build -trimpath -buildmode=c-archive -ldflags="-s -w" \
      -o ../Lib/Linux/"$WA_LIB_ARCH"/libwa.a .
    cd ../../../..

    echo "=== [6/6] Rust ==="
    cd Source/Rust
    cargo build --release --target "$RUST_TARGET"
    mkdir -p lib/Linux/"$HOST_ARCH"
    cp target/"$RUST_TARGET"/release/libdora_runtime.a lib/Linux/"$HOST_ARCH"/
    cd ../..

    echo "=== CMake link ==="
    cd Projects/Linux
    [ -d build ] || mkdir build
    cd ../../Tools/tolua++ && lua tolua++.lua && cd ../../Projects/Linux
    cd build && cmake -DCMAKE_BUILD_TYPE=release ..
    make -j"$NIX_BUILD_CORES"
    cd ../../..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/dora-ssr
    DORA_BIN=$(find Projects/Linux/build -name dora-ssr -type f -executable | head -1)
    if [ -z "$DORA_BIN" ]; then
      DORA_BIN=$(find Projects/Linux/build -name dora-ssr -type f | head -1)
    fi
    install -Dm755 "$DORA_BIN" $out/libexec/dora-ssr
    cp -r Assets $out/share/dora-ssr/Assets
    install -Dm644 LICENSE.txt "$out/share/licenses/dora-ssr/LICENSE.txt"
    install -Dm644 LICENSES.3rdparty.md "$out/share/licenses/dora-ssr/LICENSES.3rdparty.md"
    install -Dm644 Source/3rdParty/spine/LICENSE "$out/share/licenses/dora-ssr/Spine-Runtimes-License"
    makeWrapper "$out/libexec/dora-ssr" "$out/bin/dora-ssr" \
      --add-flags "--asset $out/share/dora-ssr/Assets" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          alsa-lib
          libpulseaudio
          systemdLibs
        ]
      }"

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    "$out/bin/dora-ssr" cli --help > /dev/null

    runHook postInstallCheck
  '';

  meta = {
    description = "Cross-platform game engine for making 2D and 3D games";
    homepage = "https://dora-ssr.net/";
    license = [
      lib.licenses.mit
      lib.licenses.unfreeRedistributable
    ];
    maintainers = [ lib.maintainers.uuxyz ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "dora-ssr";
  };
})
