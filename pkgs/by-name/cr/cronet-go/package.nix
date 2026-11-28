{
  lib,
  buildGoModule,
  fetchFromGitHub,
  replaceVars,
  stdenvNoCC,
  symlinkJoin,

  # nativeBuildInputs
  buildPackages,
  gn,
  ninja,
  python3,
  xcbuild,

  # propagatedBuildInputs
  apple-sdk_26,

  # buildInputs
  darwin,
}:
let
  llvmCcAndBintools = symlinkJoin {
    name = "llvmCcAndBintools";
    paths = [
      buildPackages.rustc.llvmPackages.llvm
      buildPackages.rustc.llvmPackages.stdenv.cc
    ];
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cronet-go";
  # NOTE: https://github.com/SagerNet/sing-box/blob/stable/.github/CRONET_GO_VERSION
  version = "154.0.8037.49-2";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = "cronet-go";
    # NOTE: keep rev for easier overriding
    rev = "e265295f7be0bc2209ec36078028667e6b9c217e";
    fetchSubmodules = true;
    hash = "sha256-3rxR8bRsh0EJQJ6fqVOS/7E+OO001b9BvQM1Q7QdIyM=";
  };

  patches = [
    ./cflags.patch
  ]
  ++ lib.optional stdenvNoCC.hostPlatform.isDarwin (
    replaceVars ./libresolv.patch {
      libresolv = lib.getInclude darwin.libresolv;
    }
  );

  postPatch = ''
    patchShebangs --build naiveproxy/src/build/toolchain/apple/linker_driver.py

    sslDir="naiveproxy/src/net/data/ssl/chrome_root_store"
    # Check existence
    grep -Fq '# CN=emSign ECC Root CA - G3,' "$sslDir/root_store.textproto"
    grep -Fxq '# 86a1ecba089c4a8d3bbe2734c612ba341d813e043cf9e8a862cd5c57a36bbe6b' "$sslDir/root_store.certs"
    # Remove emSign ECC Root CA - G3 from root store, which is compromised.
    sed -i '/^# CN=emSign ECC Root CA - G3,/,/^}/d' "$sslDir/root_store.textproto"
    sed -i \
      '/^# 86a1ecba089c4a8d3bbe2734c612ba341d813e043cf9e8a862cd5c57a36bbe6b$/,/^-----END CERTIFICATE-----$/d' \
      "$sslDir/root_store.certs"
  '';

  nativeBuildInputs = [
    buildPackages.rustc.llvmPackages.bintools
    ninja
    python3
  ]
  ++ lib.optional stdenvNoCC.hostPlatform.isDarwin xcbuild;

  # for statically linking to libcronet.a
  propagatedBuildInputs = lib.optional stdenvNoCC.hostPlatform.isDarwin apple-sdk_26;

  buildPhase = ''
    runHook preBuild

    ${lib.getExe finalAttrs.passthru.build-naive} build
    ${lib.getExe finalAttrs.passthru.build-naive} package --local
    ${lib.getExe finalAttrs.passthru.build-naive} package

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r lib include include_cgo.go $out/

    runHook postInstall
  '';

  passthru = {
    build-naive = buildGoModule {
      pname = finalAttrs.pname + "-build-naive";
      inherit (finalAttrs) version src;
      vendorHash = "sha256-pyeE+JPuRQEjNzrF+o9jslBcBM1vruuL+I/DCIa2BG0=";
      patches = [
        (replaceVars ./build-naive.patch {
          gn = lib.getExe gn;
          clang_base_path = llvmCcAndBintools;
        })
      ];
      subPackages = [ "cmd/build-naive" ];
      meta.mainProgram = "build-naive";
    };
  };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Go bindings for naiveproxy";
    homepage = "https://github.com/SagerNet/cronet-go";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      prince213
      moraxyc
    ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
