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
  version = "1.0.3-unstable-2024-09-25";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libtatsu";
    rev = "263f3b315d17cdd500b46bb122163df162f769e0";
    hash = "sha256-LnjHAgzL+EsxLyRRkVP40Iuhsi/YO8HDwVd98eV7UEI=";
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
