{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kati-unstable";
  version = "0-unstable-2026-02-12";

  src = fetchFromGitHub {
    owner = "google";
    repo = "kati";
    rev = "985493689b70e28970952bde44ac2a8433257b5e";
    sha256 = "sha256-fn+eA/TBmiyQYeUQvviL/zc9qxUYfW1BaeqNCILsk+w=";
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
    maintainers = with lib.maintainers; [ danielfullmer ];
  };
})
