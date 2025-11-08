{
  bcunit,
  bc-decaf,
  mkLinphoneDerivation,
  bc-mbedtls,
  lib,

  # tests
  testers,
}:
mkLinphoneDerivation (finalAttrs: {
  pname = "bctoolbox";

  propagatedBuildInputs = [
    bcunit
    bc-decaf
    bc-mbedtls
  ];

  cmakeFlags = [
    "-DENABLE_STRICT=NO"

    "-DENABLE_MBEDTLS=YES"
    "-DENABLE_OPENSSL=NO"
  ];

  strictDeps = true;

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [
        "BCToolbox"
      ];
    };
  };

  meta = {
    description = "Utilities library for Linphone";
    mainProgram = "bctoolbox_tester";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jluttine
      naxdy
      raskin
    ];
  };
})
