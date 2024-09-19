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
    hash = "sha256-DBXmYaT6SO7eSTTUrU/iQY59bpbEoTkOulJtWw8mYkQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libplist
  ];

  buildInputs = [
    curl
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libtatsu";
    description = "Library handling the communication with Apple's Tatsu Signing Server (TSS).";
    longDescription = ''
      The main purpose of this library is to allow creating TSS request payloads, sending them to Apple's TSS server, and retrieving and processing the response.
    '';
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ frontear ];
  };
})
