{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  autoconf-archive,
  automake,
  libtool,
  gettext,
  flex,
  perl,
  pkg-config,
  pcsclite,
  libusb1,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.1.13";
  pname = "acsccid";

  src = fetchurl {
    url = "mirror://sourceforge/acsccid/acsccid-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-ixmroQPsA8RIudG1YsgyL40v83zyHUy4sM9SLF84XJ8=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    autoconf-archive
    automake
    libtool
    gettext
    flex
    perl
  ];

  buildInputs = [
    pcsclite
    libusb1
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  configureFlags = [
    "--enable-usbdropdir=${placeholder "out"}/pcsc/drivers"
  ];

  doCheck = true;

  postPatch = ''
    substituteInPlace src/Makefile.in \
      --replace-fail '$(INSTALL_UDEV_RULE_FILE)' ""
    patchShebangs src/convert_version.pl
    patchShebangs src/create_Info_plist.pl
  '';

  meta = {
    description = "PC/SC driver for Linux/Mac OS X and it supports ACS CCID smart card readers";
    longDescription = ''
      acsccid is a PC/SC driver for Linux/Mac OS X and it supports ACS CCID smart card
      readers. This library provides a PC/SC IFD handler implementation and
      communicates with the readers through the PC/SC Lite resource manager (pcscd).

      acsccid is based on ccid. See CCID free software driver for more
      information:
      https://ccid.apdu.fr/

      It can be enabled in /etc/nixos/configuration.nix by adding:
        services.pcscd.enable = true;
        services.pcscd.plugins = [ pkgs.acsccid ];
    '';
    homepage = "http://acsccid.sourceforge.net";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
