{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libplist,
  curl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libtatsu";
  version = "1.0.3-unstable-2024-09-18";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libtatsu";
    rev = "1e161fc19566260b195887804ec746636635af64";
    hash = "";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libplist
    curl
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libtatsu";
    description = "Library handling the communication with Apple's Tatsu Signing Server (TSS).";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ frontear ];
  };
})
