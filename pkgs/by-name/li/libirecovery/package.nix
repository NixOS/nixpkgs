{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libusb1,
  readline,
  libimobiledevice-glue,
}:

stdenv.mkDerivation rec {
  pname = "libirecovery";
  version = "1.2.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    hash = "sha256-R+oBC7F4op0qoIk3d/WqS4MwzZY3WMAMIqlJfJb188Q=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libusb1
    readline
    libimobiledevice-glue
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  # Packager note: Not clear whether this needs a NixOS configuration,
  # as only the `idevicerestore` binary was tested so far (which worked
  # without further configuration).
  configureFlags = [
    "--with-udevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    ''--with-udevrule="OWNER=\"root\", GROUP=\"myusergroup\", MODE=\"0660\""''
  ];

  meta = with lib; {
    description = "Library and utility to talk to iBoot/iBSS via USB on Mac OS X, Windows, and Linux";
    longDescription = ''
      libirecovery is a cross-platform library which implements communication to
      iBoot/iBSS found on Apple's iOS devices via USB. A command-line utility is also
      provided.
    '';
    homepage = "https://github.com/libimobiledevice/libirecovery";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ nh2 ];
    mainProgram = "irecovery";
    platforms = platforms.unix;
  };
}
