{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfmvoice";
  version = "0-unstable-2024-06-06";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "libfmvoice";
    rev = "cd89a6a386b3b17c74b1caca11e297b2748cf90d";
    hash = "sha256-yak+pKxkrKOX/qgtwpldjd85deE/JB040bVjDD1mo7A=";
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
