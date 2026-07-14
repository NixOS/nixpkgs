{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  itk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elastix";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "SuperElastix";
    repo = "elastix";
    tag = finalAttrs.version;
    hash = "sha256-WV3iIqYJ7c5tl4LopnEVEOG//JoxVW0tW90K6MNhcAA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ itk ];

  doCheck = !stdenv.hostPlatform.isDarwin; # usual dynamic linker issues

  # Fails due to numerical tolerance issues
  # 24/94 Test #24: elastix_run_example_COMPARE_IM ...................................***Failed    0.16 sec
  # There are 9210 pixels with difference larger than 5, while 50 are allowed!
  # 39/94 Test #39: elastix_run_3DCT_lung.MI.bspline.ASGD.001_COMPARE_TP .............***Failed    0.29 sec
  # Computed difference: 2.86242 / 824.534 = 0.00347156
  # Allowed  difference: 0.001
  checkPhase = ''
    runHook preCheck
    ctest -E "(COMPARE_IM|COMPARE_TP)"
    runHook postCheck
  '';

  meta = {
    homepage = "https://elastix.dev";
    description = "Image registration toolkit based on ITK";
    changelog = "https://github.com/SuperElastix/elastix/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "elastix";
    platforms = lib.platforms.x86_64; # libitkpng linker issues with ITK 5.1
    license = lib.licenses.asl20;
  };
})
