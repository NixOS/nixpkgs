{
  cmake,
  ninja,
  pkg-config,
  bun,
  rustPlatform,
  nodejs,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,

  lib,
  stdenvNoCC,
  stdenv,
  pkgsi686Linux,
  libx11,
  libxi,
  libxtst,
  re2,

  openssl,
  curl,
  minizip-ng,
  bzip2,
  xz,
  zstd,
  nlohmann_json,
  zlib,

}:
stdenv.mkDerivation (finalAttrs: {
  pname = "millennium";
  version = "3.6.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "SteamClientHomebrew";
    repo = "Millennium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UZQSHMsAaYTcx1TDAI7FTqVRsMpB1jLBL8kYKivwbYo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    bun
    nodejs
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
  ];

  cmakeFlags = [
    (lib.cmakeBool "DISTRO_NIX" true)
    (lib.cmakeBool "MILLENNIUM_BUILD_TESTS" false)
  ];

  typescript-deps = stdenvNoCC.mkDerivation {
    pname = "millennium-typescript-deps";
    inherit (finalAttrs) src version;

    sourceRoot = "${finalAttrs.src.name}/src/typescript";

    nativeBuildInputs = [
      writableTmpDirAsHomeHook
      bun
    ];

    buildPhase = ''
      bun install  --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*" \
        --cpu="*"

      (cd ttc && bun node_modules/.bin/rollup -c)
    '';

    installPhase = ''
      mkdir -p $out
      for dir in "./." "ttc"  "sdk" "frontend"; do
          mkdir -p "$out/src/typescript/$dir"
          cp -r "$dir/node_modules" "$out/src/typescript/$dir/node_modules"
      done

      cp -r "ttc/dist" "$out/src/typescript/ttc/dist"
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-HrgEEmrBjirAkOv6v2qe3XWsNlNuCUOTbOkUfUuCRP4=";
  };

  cargoRoot = "src/instrumentation/loopback";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-8XGEBVYgNYEgkfR67m5pKxCEovSAhctAWoB87Y5JAuM=";
  };

  buildInputs = [
    libx11
    libxi
    libxtst
    re2
    openssl
    curl
    minizip-ng
    bzip2
    xz
    zstd
    nlohmann_json
    zlib
  ];

  postPatch = ''
     substituteInPlace src/system/environment.cc \
       --replace-fail "/usr/lib/millennium/libmillennium_x64.so" "${placeholder "out"}/lib/libmillennium_x64.so"
     substituteInPlace src/bootstrap/linux/libmillennium_bootstrap_x64.c \
    --replace-fail '#define MILLENNIUM_DEFAULT_LIBRARY_DIR "/usr/lib/millennium"' \
                   '#define MILLENNIUM_DEFAULT_LIBRARY_DIR "${placeholder "out"}/lib"'

     cp -r ${finalAttrs.typescript-deps}/src .
     chmod -R u+w src/typescript/ttc/dist

     patchShebangs src/typescript/node_modules
     for dir in "ttc/" "sdk/" "frontend/"; do
         (cd "src/typescript/$dir" && bun run build)
     done

  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/

    install -Dm755 libmillennium_x64.so            $out/lib/libmillennium_x64.so
    install -Dm755 libmillennium_luavm_x64         $out/lib/libmillennium_luavm_x64
    install -Dm755 libmillennium_bootstrap_x64.so  $out/lib/libmillennium_bootstrap_x64.so

    install -Dm755 libmillennium_hhx64.so          $out/lib/libmillennium_hhx64.so
    install -Dm755 libmillennium_pvs64             $out/lib/libmillennium_pvs64
    install -Dm755 libmillennium_bootstrap_hhx64.so $out/lib/libmillennium_bootstrap_hhx64.so
    runHook postInstall
  '';

  postFixup = ''
    patchelf --force-rpath --set-rpath \
      "$(patchelf --print-rpath $out/lib/libmillennium_x64.so)" $out/lib/libmillennium_x64.so
    patchelf --force-rpath --set-rpath \
      "$(patchelf --print-rpath $out/lib/libmillennium_bootstrap_x64.so)" $out/lib/libmillennium_bootstrap_x64.so
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage=typescript-deps"
    ];
  };

  meta = {
    homepage = "https://github.com/SteamClientHomebrew/Millennium";
    license = lib.licenses.mit;
    description = "Modding framework to create, manage and use themes/plugins for Steam";
    longDescription = "An open-source low-code modding framework to create, manage and use themes/plugins for the desktop Steam Client without any low-level internal interaction or overhead";

    maintainers = [ lib.maintainers.DrymarchonShaun ];
    platforms = [ "x86_64-linux" ];
  };

})
