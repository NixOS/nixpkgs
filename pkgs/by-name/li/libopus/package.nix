{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchzip,
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

let
  models = fetchzip (finalAttrs: {
    pname = "opus-models";
    version = "a5177ec6fb7d15058e99e57029746100121f68e4890b1467d4094aa336b6013e";
    url = "https://media.xiph.org/opus/models/opus_data-${finalAttrs.version}.tar.gz";
    hash = "sha256-aCOYMJoOGgdFCYZdFlUKiXjzssQKlQnCsTD3i5gGzCA=";
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libopus";
  version = "1.6.1";

  src = fetchFromGitLab {
    domain = "gitlab.xiph.org";
    owner = "xiph";
    repo = "opus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I1f+J//ZJBMj88+PQhsYBjz3fm4Ll3ckZD+fYa6/3Y0=";
  };

  patches = [
    # Some tests time out easily on slower machines
    ./test-timeout.patch
  ];

  postPatch = ''
    patchShebangs meson/
    echo 'PACKAGE_VERSION="${finalAttrs.version}"' > package_version
    ln -s ${models}/* ./dnn/
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

  doCheck = !stdenv.hostPlatform.isi686 && !stdenv.hostPlatform.isAarch32; # test_unit_LPC_inv_pred_gain fails

  passthru = {
    updateScript = gitUpdater {
      url = "https://gitlab.xiph.org/xiph/opus.git";
      rev-prefix = "v";
    };

    inherit models;

    tests = {
      inherit ffmpeg-headless;

      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
        moduleNames = [ "opus" ];
      };
    };
  };

  meta = {
    description = "Open, royalty-free, highly versatile audio codec";
    homepage = "https://opus-codec.org/";
    changelog = "https://gitlab.xiph.org/xiph/opus/-/releases/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      getchoo
      jopejoe1
    ];
  };
})
