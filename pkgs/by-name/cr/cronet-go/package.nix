{
  apple-sdk_15,
  buildGoModule,
  buildPackages,
  darwin,
  fetchFromGitHub,
  gn,
  lib,
  ninja,
  python3,
  replaceVars,
  stdenvNoCC,
  symlinkJoin,
  xcbuild,
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
  version = "148.0.7778.96-1";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = "cronet-go";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-wTgJy/ZfsoTpRJCEEDEAQo/bVK7Tn2z5qnAURveWnKg=";
  };

  patches = [
    ./cflags.patch
  ]
  ++ lib.optional stdenvNoCC.hostPlatform.isDarwin (
    replaceVars ./libresolv.patch {
      libresolv = lib.getInclude darwin.libresolv;
    }
  );

  nativeBuildInputs = [
    buildPackages.rustc.llvmPackages.bintools
    ninja
    python3
  ]
  ++ lib.optional stdenvNoCC.hostPlatform.isDarwin xcbuild;

  buildInputs = lib.optional stdenvNoCC.hostPlatform.isDarwin apple-sdk_15;

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
    maintainers = with lib.maintainers; [ prince213 ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
