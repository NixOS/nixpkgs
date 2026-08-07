{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mposplit";
  version = "v0.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AlbrechtL";
    repo = "mposplit";
    rev = "v0.1";
    hash = "sha256-nrW9yceqdGRHtOs2V4iNHLinVf8cB/QBNzx33FAvB8E=";
  };

  buildPhase = "gcc -o mposplit mposplit.c";
  installPhase = "mkdir -p $out/bin; mv mposplit $out/bin/mposplit";

  meta = {
    description = "A small tool to convert a 3D MPO-file into two JPEG-files.";
    homepage = "https://github.com/AlbrechtL/mposplit";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "mposplit";
    maintainers = with lib.maintainers; [ annoyingrains ];
  };
})
