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

}:
pkgsi686Linux.stdenv.mkDerivation (finalAttrs: {
  pname = "millennium";
  version = "3.6.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "SteamClientHomebrew";
    repo = "Millennium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sNpoyJ+IjrTiDGfX2QiKVg4jkrJR7n9PdBeOYJSS4n8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    bun
    nodejs
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
    outputHash = "sha256-c3aw+Nznk5ciamIQ+7l7MwB0e7pezzZTtMP97z5U1e4=";
  };

  millennium-64-bit-libs = stdenv.mkDerivation (finalAttrs64: {
    pname = "millennium-64-bit";
    inherit (finalAttrs) src version;

    nativeBuildInputs = finalAttrs.nativeBuildInputs ++ [
      rustPlatform.cargoSetupHook
      rustPlatform.rust.cargo
      rustPlatform.rust.rustc
    ];

    cargoRoot = "src/instrumentation/loopback";
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs64) src cargoRoot;
      hash = "sha256-8XGEBVYgNYEgkfR67m5pKxCEovSAhctAWoB87Y5JAuM=";
    };

    buildInputs = [
      libx11
      libxi
      libxtst
      re2
    ];

    cmakeFlags = finalAttrs.cmakeFlags ++ [
      (lib.cmakeBool "MILLENNIUM_NIX_64BIT" true)
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/
      install -Dm555 libmillennium_hhx64.so           $out/lib/libmillennium_hhx64.so
      install -Dm555 libmillennium_pvs64              $out/lib/libmillennium_pvs64
      install -Dm555 libmillennium_bootstrap_hhx64.so $out/lib/libmillennium_bootstrap_hhx64.so
      runHook postInstall
    '';
  });

  buildInputs = [
    pkgsi686Linux.libx11
    pkgsi686Linux.libxi
    pkgsi686Linux.libxtst
    pkgsi686Linux.openssl
    pkgsi686Linux.curl
    pkgsi686Linux.minizip-ng
    pkgsi686Linux.bzip2
    pkgsi686Linux.xz
    pkgsi686Linux.zstd
    pkgsi686Linux.nlohmann_json
    pkgsi686Linux.zlib
    pkgsi686Linux.luajit
  ];

  postPatch = ''
    substituteInPlace src/system/environment.cc \
      --replace-fail "/usr/lib/millennium/libmillennium_x86.so" "${placeholder "out"}/lib/libmillennium_x86.so"
    substituteInPlace src/bootstrap/linux/libmillennium_bootstrap.c \
      --replace-fail "/usr/lib/millennium/libmillennium_x86.so" "${placeholder "out"}/lib/libmillennium_x86.so"

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
    install -Dm555 libmillennium_x86.so           $out/lib/libmillennium_x86.so
    install -Dm555 libmillennium_luavm_x86        $out/lib/libmillennium_luavm_x86
    install -Dm555 libmillennium_bootstrap_x86.so $out/lib/libmillennium_bootstrap_x86.so
    cp -r ${finalAttrs.millennium-64-bit-libs}/lib/* $out/lib/
    runHook postInstall
  '';

  postFixup = ''
    patchelf --force-rpath --set-rpath \
      "$(patchelf --print-rpath $out/lib/libmillennium_x86.so)" $out/lib/libmillennium_x86.so
    patchelf --force-rpath --set-rpath \
      "$(patchelf --print-rpath $out/lib/libmillennium_bootstrap_x86.so)" $out/lib/libmillennium_bootstrap_x86.so
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
    platforms = [ "i686-linux" ];
  };

})
