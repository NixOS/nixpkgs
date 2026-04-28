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
  version = "147.0.7727.49-1-unstable-2026-04-10";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = "cronet-go";
    rev = "335e5bef5d88fc4474c9a70b865561f45a67de83";
    fetchSubmodules = true;
    hash = "sha256-tWrMZ6F6zqLFJWPg8NvO6W/5bjEsemvQx4EIrz2aQ/c=";
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
      vendorHash = "sha256-tVIKTznnducPfATK151TpC3UV2U852TyclBTSgh/H6U=";
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
