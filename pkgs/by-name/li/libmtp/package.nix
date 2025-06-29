{
  stdenv,
  autoconf,
  automake,
  fetchFromGitHub,
  gettext,
  lib,
  libiconv,
  libtool,
  libusb1,
  pkg-config,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "libmtp";
  version = "1.1.22";

  src = fetchFromGitHub {
    owner = "libmtp";
    repo = "libmtp";
    rev = "libmtp-${builtins.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "sha256-hIH6W8qQ6DB4ST7SlFz6CCnLsEGOWgmUb9HoHMNA3wY=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
    pkg-config
  ];

  buildInputs = [ libiconv ];

  propagatedBuildInputs = [ libusb1 ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [ "--with-udev=${placeholder "out"}/lib/udev" ];

  configurePlatforms = [
    "build"
    "host"
  ];

  makeFlags =
    lib.optionals (stdenv.hostPlatform.isLinux && !stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      [
        "MTP_HOTPLUG=${buildPackages.libmtp}/bin/mtp-hotplug"
      ];

  enableParallelBuilding = true;

  doInstallCheck = true;

  meta = with lib; {
    homepage = "https://github.com/libmtp/libmtp";
    description = "Implementation of Microsoft's Media Transfer Protocol";
    longDescription = ''
      libmtp is an implementation of Microsoft's Media Transfer Protocol (MTP)
      in the form of a library suitable primarily for POSIX compliant operating
      systems. We implement MTP Basic, the stuff proposed for standardization.
    '';
    platforms = platforms.unix;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
