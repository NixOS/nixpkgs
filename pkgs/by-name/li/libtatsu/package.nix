{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,

  autoreconfHook,
  pkg-config,

  curl,
  libplist,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libtatsu";
  version = "1.0.4-unstable-2024-10-10";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libtatsu";
    rev = "ec295dd6585a900207125d41fab8535ce0c8d3dc";
    hash = "sha256-xp0he1MFaIk2DUCsgs/pTmGEpLwQBiTPf/hTKSA17YE=";
  };

  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    libplist
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libtatsu";
    description = "Library handling the communication with Apple's Tatsu Signing Server (TSS).";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ frontear ];
  };
})
