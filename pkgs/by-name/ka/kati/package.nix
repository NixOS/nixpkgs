{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kati-unstable";
  version = "0-unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "google";
    repo = "kati";
    rev = "55ea1e26f4da6d52a4ddca8f36a130dc26120525";
    sha256 = "sha256-VStvrYUQIBqv9TTbMOzCJYye8BrlIcRz1pmglVAabl4=";
  };

  patches = [
    (replaceVars ./version.patch {
      version = finalAttrs.src.rev;
    })
  ];

  installPhase = ''
    install -D ckati $out/bin/ckati
  '';

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
})
