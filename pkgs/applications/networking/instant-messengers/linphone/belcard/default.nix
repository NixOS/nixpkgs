{
  bctoolbox,
  belr,
  lib,
  mkLinphoneDerivation,

  # tests
  testers,
}:
mkLinphoneDerivation (finalAttrs: {
  pname = "belcard";

  propagatedBuildInputs = [
    bctoolbox
    belr
  ];

  cmakeFlags = [
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
  ];

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [
        "BelCard"
      ];
    };
  };

  meta = {
    description = "C++ library to manipulate VCard standard format. Part of the Linphone project";
    license = lib.licenses.gpl3Only;
  };
})
