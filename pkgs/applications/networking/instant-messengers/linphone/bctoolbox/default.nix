{
  bcunit,
  bc-decaf,
  mkLinphoneDerivation,
  openssl,
  lib,

  # tests
  testers,
}:
mkLinphoneDerivation (finalAttrs: {
  pname = "bctoolbox";

  propagatedBuildInputs = [
    bcunit
    bc-decaf
    openssl
  ];

  cmakeFlags = [
    "-DENABLE_STRICT=NO"

    # mbedtils does not build
    "-DENABLE_MBEDTLS=NO"
    "-DENABLE_OPENSSL=YES"
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
