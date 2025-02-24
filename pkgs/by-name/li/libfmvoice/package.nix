{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfmvoice";
  version = "0-unstable-2024-12-11";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "libfmvoice";
    rev = "896a67d0dab6144d30abb0c5cfbebe483196fed7";
    hash = "sha256-aquI9mEwAI2agUnuCUSEfxIDkmI1RwQeNQEq/+x/akg=";
  };

  outputs = [
    "out"
    "bin"
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  buildInputs = [ zlib ];

  buildFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 libfmvoice.a $out/lib/libfmvoice.a

    for header in *.h; do
      install -Dm644 $header $out/include/$header
    done

    for prog in $(grep 'PROGS:=' Makefile | cut -d'=' -f2); do
      install -Dm755 $prog $bin/bin/$prog
    done

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "C library for loading, saving and converting FM sound chip voice files in various formats";
    homepage = "https://github.com/vampirefrog/libfmvoice";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
})
