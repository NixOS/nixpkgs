{
  lib,
  swiftPackages,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "smc-fuzzer";
  version = "0-unstable-2020-12-23";

  src = fetchFromGitHub {
    repo = "smc-fuzzer";
    owner = "theopolis";
    rev = "ed60c4efeddea8a9778a976c49c650eee3840eac";
    hash = "sha256-FyiFSVeO46UnBrpC8AhSuGe7alo37pT8J1qQWGPqV2U=";
  };

  buildInputs = [ swiftPackages.apple_sdk.frameworks.AppKit ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 smc -t $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Apple SMC (System Management Controller) API fuzzer";
    longDescription = ''
      smc-fuzzer uses the AppleSMC IOKit interface and a userland API for
      interacting with the System Management Controller (Mac embedded
      controllers). The tool focuses on the SMC key/value API.

      smc-fuzzer is not just useful for fuzzing the SMC itself: it can also be
      used to explicitly control or query the SMC.  That makes it useful in
      system management, e.g. controlling and querying the charge status of an
      Apple laptop.
    '';
    homepage = "https://github.com/theopolis/smc-fuzzer";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hraban ];
    mainProgram = "smc";
    platforms = lib.platforms.darwin;
  };
}
