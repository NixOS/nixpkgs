{
  lib,
  stdenv,
  fetchurl,
  gitUpdater,
  meson,
  python3,
  ninja,
  fixedPoint ? false,
  withCustomModes ? true,
  withIntrinsics ? stdenv.hostPlatform.isAarch || stdenv.hostPlatform.isx86,
  withAsm ? false,

  # tests
  ffmpeg-headless,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopus";
  version = "1.5.2";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/opus/opus-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZcHS94ufL7IAgsOMvkfJUa1YOTRYduRpQWEu6H+afOE=";
  };

  patches = [
    # Some tests time out easily on slower machines
    ./test-timeout.patch
  ];

  postPatch = ''
    patchShebangs meson/
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    python3
    ninja
  ];

  mesonFlags = [
    (lib.mesonBool "fixed-point" fixedPoint)
    (lib.mesonBool "custom-modes" withCustomModes)
    (lib.mesonEnable "intrinsics" withIntrinsics)
    (lib.mesonEnable "rtcd" (withIntrinsics || withAsm))
    (lib.mesonEnable "asm" withAsm)
    (lib.mesonEnable "docs" false)
  ];

  doCheck = !stdenv.isi686 && !stdenv.isAarch32; # test_unit_LPC_inv_pred_gain fails

  passthru = {
    updateScript = gitUpdater {
      url = "https://gitlab.xiph.org/xiph/opus.git";
      rev-prefix = "v";
    };

    tests = {
      inherit ffmpeg-headless;

      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
        moduleNames = [ "opus" ];
      };
    };
  };

  meta = with lib; {
    description = "Open, royalty-free, highly versatile audio codec";
    homepage = "https://opus-codec.org/";
    changelog = "https://gitlab.xiph.org/xiph/opus/-/releases/v${finalAttrs.version}";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ getchoo ];
  };
})
