{
  lib,
  buildPackages,
  stdenv,
  fetchFromGitHub,
  ffmpeg-full,
  libaom,
  meson,
  nasm,
  ninja,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvmaf";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "netflix";
    repo = "vmaf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kypmbtIOHCu9Hd09TugPbbOA9O4LkBqzqRK9el1ncwo=";
  };

  sourceRoot = "${finalAttrs.src.name}/libvmaf";

  nativeBuildInputs = [
    meson
    ninja
    nasm
    (buildPackages.callPackage ./xxd.nix { })
  ];

  # Upstream forgot to bump project version in the v3.2.1 tag
  postPatch = lib.optionalString (finalAttrs.version == "3.2.1") ''
    substituteInPlace meson.build --replace-fail "version : '3.2.0'" "version : '3.2.1'"
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

  meta = {
    description = "Perceptual video quality assessment based on multi-method fusion (VMAF)";
    homepage = "https://github.com/Netflix/vmaf";
    changelog = "https://github.com/Netflix/vmaf/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2Patent;
    maintainers = [ lib.maintainers.cfsmp3 ];
    mainProgram = "vmaf";
    platforms = lib.platforms.unix;
  };
})
