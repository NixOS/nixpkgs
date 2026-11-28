{
  bcunit,
  bc-decaf,
  mkLinphoneDerivation,
  openssl,
  stdenv,
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

    crypto = testers.runCommand {
      name = "${finalAttrs.pname}-crypto-test";
      nativeBuildInputs = [ finalAttrs.finalPackage ];
      script = ''
        bctoolbox-tester --suite Crypto --suite 'Encrypted vfs'
        touch $out
      '';
    };
  };

  meta = {
    description = "Utilities library for Linphone";
    mainProgram = "bctoolbox-tester";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jluttine
      naxdy
      raskin
    ];
  };
})
