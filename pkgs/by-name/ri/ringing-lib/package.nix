{
  gcc14Stdenv,
  fetchFromGitHub,
  lib,
  pkg-config,
  readline,
  xercesc,
  unstableGitUpdater,
}:

gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "ringing-lib";
  version = "0-unstable-2025-11-10";

  src = fetchFromGitHub {
    owner = "ringing-lib";
    repo = "ringing-lib";
    rev = "6a58b9434b073df4dba5e851d23d397c621e9686";
    hash = "sha256-XQj94IGxo39foqstC/BdpRAAXRiMu74BZdpBvywA6S8=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    readline
    xercesc
  ];

  installPhase = ''
    runHook preInstall
    make install PREFIX=''$out
    runHook postInstall
  '';

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  meta = {
    description = "Library of C++ classes and utilities for change ringing";
    homepage = "https://ringing-lib.github.io/";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    maintainers = with lib.maintainers; [ jshholland ];
    platforms = lib.platforms.linux;
  };
})
