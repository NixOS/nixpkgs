{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  symlinkJoin,
  rustPlatform,
}:
let

  src = fetchFromGitHub {
    owner = "google";
    repo = "kati";
    rev = "55ea1e26f4da6d52a4ddca8f36a130dc26120525";
    sha256 = "sha256-VStvrYUQIBqv9TTbMOzCJYye8BrlIcRz1pmglVAabl4=";
  };

  version = "0-unstable-2026-09-18";

  rkati = rustPlatform.buildRustPackage {
    pname = "rkati";
    inherit src version;

    cargoHash = "sha256-FqfxF2TmjCA1A8xAmI1/ctpECci69ykPaLS6VvxM6Sc=";
  };

  ckati = stdenv.mkDerivation (finalAttrs: {
    # pname = "kati-unstable";
    pname = "ckati";

    inherit src version;

    patches = [
      (replaceVars ./version.patch {
        version = finalAttrs.src.rev;
      })
    ];

    installPhase = ''
      install -Dm755 ckati $out/bin/ckati
    '';
  });

in

symlinkJoin {
  name = "kati-unstable-${version}";

  paths = [
    ckati
    rkati
  ];

  meta = {
    description = "Experimental GNU make clone";
    mainProgram = "ckati";
    homepage = "https://github.com/google/kati";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      danielfullmer
      evanwporter
    ];
  };
}
