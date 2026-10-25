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

stdenv.mkDerivation (finalAttrs: {
  pname = "libmtp";
  version = "1.1.23";

  src = fetchFromGitHub {
    owner = "libmtp";
    repo = "libmtp";
    rev = "libmtp-${builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    sha256 = "sha256-FlPj9PEeOAWabU11dFTzDgY9TBbgmJclbeL0iULYw6A=";
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

  preConfigure = ''
    autopoint -f
    NOCONFIGURE=1 ./autogen.sh
  '';

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

  meta = {
    homepage = "https://github.com/libmtp/libmtp";
    description = "Implementation of Microsoft's Media Transfer Protocol";
    longDescription = ''
      libmtp is an implementation of Microsoft's Media Transfer Protocol (MTP)
      in the form of a library suitable primarily for POSIX compliant operating
      systems. We implement MTP Basic, the stuff proposed for standardization.
    '';
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
})
