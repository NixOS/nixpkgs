{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg-full,
  libaom,
  meson,
  nasm,
  ninja,
  testers,
  windows,
  xxd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvmaf";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "netflix";
    repo = "vmaf";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-6mwU2so1YM2pyWkJbDHVl443GgWtQazbBv3gTMBq5NA=";
  };

  sourceRoot = "${finalAttrs.src.name}/libvmaf";

  nativeBuildInputs = [
    meson
    ninja
    nasm
    xxd
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isMinGW windows.pthreads;

  postPatch = lib.optionalString stdenv.hostPlatform.isFreeBSD ''
    substituteInPlace meson.build --replace-fail '_XOPEN_SOURCE=600' '_XOPEN_SOURCE=700'
  '';

  env =
    lib.optionalAttrs stdenv.hostPlatform.isFreeBSD {
      NIX_CFLAGS_COMPILE = "-D__BSD_VISIBLE=1";
    }
    // lib.optionalAttrs stdenv.hostPlatform.isMinGW {
      # libvmaf includes <pthread.h> and expects -lpthread on MinGW.
      # MSYS2's mingw-w64-vmaf similarly links pthread explicitly.
      NIX_LDFLAGS = "-lpthread";
    };

  mesonFlags = [ "-Denable_avx512=true" ];

  outputs = [
    "out"
    "dev"
  ];
  doCheck = false;

  passthru.tests = {
    inherit libaom ffmpeg-full;
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "libvmaf" ];
    };
  };

  meta = {
    description = "Perceptual video quality assessment based on multi-method fusion (VMAF)";
    homepage = "https://github.com/Netflix/vmaf";
    changelog = "https://github.com/Netflix/vmaf/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2Patent;
    maintainers = [ lib.maintainers.cfsmp3 ];
    mainProgram = "vmaf";
    # MSYS2 ships a working MinGW build, and nixpkgs uses libvmaf in MinGW
    # dependency chains (e.g. for AV1 tooling), so allow Windows targets.
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
