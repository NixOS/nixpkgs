{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, gperf
, kmod
, pkg-config
, util-linux
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eudev";
  version = "3.2.14";

  src = fetchFromGitHub {
    owner = "eudev-project";
    repo = "eudev";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v/szzqrBedQPRGYkZ0lV9rslCH//uqGp4PHEF0/51Lg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gperf
    pkg-config
  ];

  buildInputs = [
    kmod
    util-linux
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  makeFlags = [
    "hwdb_bin=/var/lib/udev/hwdb.bin"
    "udevrulesdir=/etc/udev/rules.d"
  ];

  preInstall = ''
    # Disable install-exec-hook target, as it conflicts with our move-sbin
    # setup-hook

    sed -i 's;$(MAKE) $(AM_MAKEFLAGS) install-exec-hook;$(MAKE) $(AM_MAKEFLAGS);g' src/udev/Makefile
  '';

  installFlags = [
    "localstatedir=$(TMPDIR)/var"
    "sysconfdir=$(out)/etc"
    "udevconfdir=$(out)/etc/udev"
    "udevhwdbbin=$(out)/var/lib/udev/hwdb.bin"
    "udevhwdbdir=$(out)/var/lib/udev/hwdb.d"
    "udevrulesdir=$(out)/var/lib/udev/rules.d"
  ];

  meta = {
    homepage = "https://github.com/eudev-project/eudev";
    description = "A fork of udev with the aim of isolating it from init";
    longDescription = ''
      eudev is a standalone dynamic and persistent device naming support (aka
      userspace devfs) daemon that runs independently from the init
      system. eudev strives to remain init system and linux distribution
      neutral. It is currently used as the devfs manager for more than a dozen
      different linux distributions.

      This git repo is a fork of systemd repository with the aim of isolating
      udev from any particular flavor of system initialization. In this case,
      the isolation is from systemd.

      This is a project started by Gentoo developers and testing was initially
      being done mostly on OpenRC. We welcome contribution from others using a
      variety of system initializations to ensure eudev remains system
      initialization and distribution neutral. On 2021-08-20 Gentoo decided to
      abandon eudev and a new project was established on 2021-09-14 by Alpine,
      Devuan and Gentoo contributors.
    '';
    changelog = "https://github.com/eudev-project/eudev/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ raskin AndersonTorres ];
    inherit (kmod.meta) platforms;
  };
})
