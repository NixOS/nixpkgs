{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfmvoice";
  version = "0-unstable-2024-05-30";

  src = fetchFromGitHub {
    owner = "vampirefrog";
    repo = "libfmvoice";
    rev = "0e58cfb323dc6461c705a5fadac4362a17fbec4e";
    hash = "sha256-HyGB180roo28vJ+11/ocoKu1kHpn6GxtEg9NluQsECg=";
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
