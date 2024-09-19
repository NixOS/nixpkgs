{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libplist,
  libimobiledevice-glue,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libusbmuxd";
  version = "2.1.0-unstable-2024-04-16";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libusbmuxd";
    rev = "a7f0543fb1ecb20ac7121c0fd77297200e0e43fc";
    hash = "";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libplist
    libimobiledevice-glue
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libusbmuxd";
    description = "Client library to multiplex connections from and to iOS devices";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ frontear ];
  };
})
