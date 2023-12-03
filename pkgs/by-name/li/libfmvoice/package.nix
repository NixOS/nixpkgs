{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfmvoice";
  version = "0.0.0-unstable-2023-05-21";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "libfmvoice";
    rev = "d4a2cd0ce0f934e511ef0bebbc060ba6e1b7f21f";
    hash = "sha256-GbwnXmCe/ktl4l/lAdYLg5eu49+hUwbHa61P93CQGh4=";
  };

  strictDeps = true;

  enableParallelBuilding = true;

  buildInputs = [
    zlib
  ];

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall

    for prog in $(grep 'PROGS=' Makefile | cut -d'=' -f2); do
      install -Dm755 $prog $out/bin/$prog
    done

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "C library for loading, saving and converting FM sound chip voice files in various formats";
    homepage = "https://github.com/vampirefrog/libfmvoice";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
})
