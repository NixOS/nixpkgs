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

  postPatch = lib.optionalString stdenv.hostPlatform.isFreeBSD ''
    substituteInPlace meson.build --replace-fail '_XOPEN_SOURCE=600' '_XOPEN_SOURCE=700'
  '';

  env = lib.optionalAttrs stdenv.hostPlatform.isFreeBSD {
    NIX_CFLAGS_COMPILE = "-D__BSD_VISIBLE=1";
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

  meta = with lib; {
    description = "Perceptual video quality assessment based on multi-method fusion (VMAF)";
    homepage = "https://github.com/Netflix/vmaf";
    changelog = "https://github.com/Netflix/vmaf/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = licenses.bsd2Patent;
    maintainers = [ maintainers.cfsmp3 ];
    mainProgram = "vmaf";
    platforms = platforms.unix;
  };
})
