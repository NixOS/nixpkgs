{
  autoPatchelfHook,
  boost186,
  cmake,
  fetchFromGitHub,
  gitMinimal,
  hidapi,
  lib,
  libsodium,
  libusb1,
  openssl,
  patchelf,
  pkg-config,
  protobuf_21,
  python3,
  rapidjson,
  readline,
  src,
  stdenv,
  udev,
  unbound,
  zeromq,
}:

let
  bcUr = fetchFromGitHub {
    owner = "MrCyjaneK";
    repo = "bc-ur";
    rev = "d82e7c753e710b8000706dc3383b498438795208";
    hash = "sha256-96mD5YqlJd4R5lRbavxREwaEdxp/o1bUeOjh+FEkXTw=";
  };

  polyseed = fetchFromGitHub {
    owner = "tevador";
    repo = "polyseed";
    rev = "bd79f5014c331273357277ed8a3d756fb61b9fa1";
    hash = "sha256-Vuo2FydkCNnS7OrkcevjZsqz49RzLiRq48BIg37K/AQ=";
  };

  randomwow = fetchFromGitHub {
    owner = "MrCyjaneK";
    repo = "randomwow";
    rev = "cd137b1ea7bb9f0bcb5e77b39a5c1e08ca4b4fed";
    hash = "sha256-SrYrcCAIvt0kZwVhwD46XJwacyAB9kZTyEyHxtxvrHM=";
  };

  utf8proc = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = "utf8proc";
    rev = "3de4596fbe28956855df2ecb3c11c0bbc3535838";
    hash = "sha256-DNnrKLwks3hP83K56Yjh9P3cVbivzssblKIx4M/RKqw=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cake-wallet-monero-c";
  version = "0.18.4.6-rc2-unstable-2026-08-18";
  inherit src;

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    gitMinimal
    patchelf
    pkg-config
    python3
  ];

  buildInputs = [
    boost186
    hidapi
    libsodium
    libusb1
    openssl
    protobuf_21
    rapidjson
    readline
    stdenv.cc.cc.lib
    udev
    unbound
    zeromq
  ];

  postPatch = ''
    for coin in monero wownero; do
      for patch in patches/"$coin"/*.patch; do
        git apply \
          --directory="$coin" \
          --exclude="$coin/external/bc-ur" \
          --exclude="$coin/external/polyseed" \
          --exclude="$coin/external/randomwow" \
          --exclude="$coin/external/randomx" \
          --exclude="$coin/external/utf8proc" \
          "$patch"
      done

      ln -s ${bcUr} "$coin/external/bc-ur"
      ln -s ${polyseed} "$coin/external/polyseed"
      ln -s ${utf8proc} "$coin/external/utf8proc"
    done

    rm -rf wownero/external/randomwow
    ln -s ${randomwow} wownero/external/randomwow
  '';

  configurePhase = ''
    runHook preConfigure

    cmake -S monero_libwallet2_api_c -B build-monero \
      -DMONERO_FLAVOR=monero \
      -DHOST_ABI=${stdenv.hostPlatform.config} \
      -DOUTPUT_MODE=SHARED \
      -DMANUAL_SUBMODULES=ON \
      -DReadline_ROOT_DIR=${readline.dev} \
      -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-z,noexecstack" \
      -DCMAKE_BUILD_TYPE=Release

    cmake -S wownero_libwallet2_api_c -B build-wownero \
      -DMONERO_FLAVOR=wownero \
      -DHOST_ABI=${stdenv.hostPlatform.config} \
      -DOUTPUT_MODE=SHARED \
      -DMANUAL_SUBMODULES=ON \
      -DReadline_ROOT_DIR=${readline.dev} \
      -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-z,noexecstack" \
      -DCMAKE_BUILD_TYPE=Release

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cmake --build build-monero --parallel "$NIX_BUILD_CORES"
    cmake --build build-wownero --parallel "$NIX_BUILD_CORES"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 build-monero/libmonero_wallet2_api_c.so \
      "$out/lib/libmonero_wallet2_api_c.so"
    install -Dm755 build-wownero/libwownero_wallet2_api_c.so \
      "$out/lib/libwownero_wallet2_api_c.so"
    cp -P build-monero/monero_build/external/polyseed/libpolyseed.so* \
      "$out/lib/"
    patchelf --set-rpath "$out/lib:${lib.makeLibraryPath finalAttrs.buildInputs}" \
      "$out/lib/libmonero_wallet2_api_c.so"
    patchelf --set-rpath "$out/lib:${lib.makeLibraryPath finalAttrs.buildInputs}" \
      "$out/lib/libwownero_wallet2_api_c.so"
    runHook postInstall
  '';

  meta = {
    description = "Monero and Wownero C wallet libraries for Cake Wallet";
    homepage = "https://github.com/MrCyjaneK/monero_c";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.linux;
  };
})
