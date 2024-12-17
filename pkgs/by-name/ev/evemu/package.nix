{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  python3Packages,
  libevdev,
}:

stdenv.mkDerivation rec {
  pname = "evemu";
  version = "2.7.0";

  # We could have downloaded a release tarball from cgit, but it changes hash
  # each time it is downloaded :/
  src = fetchgit {
    url = "git://git.freedesktop.org/git/evemu";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-SQDaARuqBMBVlUz+Nw6mjdxaZfVOukmzTlIqy8U2rus=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    python3Packages.python
  ];

  buildInputs = [
    python3Packages.evdev
    libevdev
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Records and replays device descriptions and events to emulate input devices through the kernel's input system";
    homepage = "https://www.freedesktop.org/wiki/Evemu/";
    license = with licenses; [
      lgpl3Only
      gpl3Only
    ];
    maintainers = [ maintainers.amorsillo ];
    platforms = platforms.linux;
  };
}
