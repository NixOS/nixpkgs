{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,

  autoreconfHook,
  pkg-config,

  libimobiledevice-glue,
  libplist,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libusbmuxd";
  version = "2.1.0-unstable-2024-04-16";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libusbmuxd";
    rev = "a7f0543fb1ecb20ac7121c0fd77297200e0e43fc";
    hash = "sha256-CETq4sguBwtIufwraMwMmzFcNm7MTkitvfM2jF2G02E=";
  };

  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libimobiledevice-glue
    libplist
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libusbmuxd";
    description = "Client library to multiplex connections from and to iOS devices";
    license = with licenses; [
      gpl2Only
      lgpl21Only
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ frontear ];
  };
})
