{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfmvoice";
  version = "0-unstable-2024-11-08";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "libfmvoice";
    rev = "1cd83789335ba7fcae4cd2081e873ad097e3270c";
    hash = "sha256-XzkFfrfXefbZLXWFDy0V6agDPjzCzG5d28znQWsmcuM=";
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
