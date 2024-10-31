{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libplist,
  libimobiledevice-glue,
}:

stdenv.mkDerivation rec {
  pname = "libusbmuxd";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    hash = "sha256-coQqNGPsqrOYbBjO0eQZQNK8ZTB+ZzfMWvQ6Z1by9PY=";
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
    export RELEASE_VERSION=${version}
  '';

  meta = {
    description = "Client library to multiplex connections from and to iOS devices";
    homepage = "https://github.com/libimobiledevice/libusbmuxd";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
