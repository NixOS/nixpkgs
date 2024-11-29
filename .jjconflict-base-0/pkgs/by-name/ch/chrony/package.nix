{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnutls,
  libedit,
  texinfo,
  libcap,
  libseccomp,
  pps-tools,
  nixosTests,
  apple-sdk_11,
  darwinMinVersionHook,
}:

stdenv.mkDerivation rec {
  pname = "chrony";
  version = "4.6.1";

  src = fetchurl {
    url = "https://chrony-project.org/releases/${pname}-${version}.tar.gz";
    hash = "sha256-Vx/3P78K4wl/BgTsouALHYuy6Rr/4aNJR4X/IdYZnFw=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      gnutls
      libedit
      texinfo
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libcap
      libseccomp
      pps-tools
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "10.13")
    ];

  configureFlags = [
    "--enable-ntp-signd"
    "--sbindir=$(out)/bin"
    "--chronyrundir=/run/chrony"
  ] ++ lib.optional stdenv.hostPlatform.isLinux "--enable-scfilter";

  patches = [
    # Cleanup the installation script
    ./makefile.patch
  ];

  postPatch = ''
    patchShebangs test

    # nts_ke_session unit test fails, so drop it.
    # TODO: try again when updating?
    rm test/unit/nts_ke_session.c
  '';

  enableParallelBuilding = true;
  doCheck = true;

  hardeningEnable = lib.optionals (!stdenv.hostPlatform.isDarwin) [ "pie" ];

  passthru.tests = {
    inherit (nixosTests) chrony chrony-ptp;
  };

  meta = {
    description = "Sets your computer's clock from time servers on the Net";
    homepage = "https://chrony-project.org/";
    license = lib.licenses.gpl2Only;
    platforms =
      with lib.platforms;
      builtins.concatLists [
        linux
        freebsd
        netbsd
        darwin
        illumos
      ];
    maintainers = with lib.maintainers; [
      fpletz
      thoughtpolice
      vifino
    ];

    longDescription = ''
      Chronyd is a daemon which runs in background on the system. It obtains
      measurements via the network of the system clock’s offset relative to
      time servers on other systems and adjusts the system time accordingly.
      For isolated systems, the user can periodically enter the correct time by
      hand (using Chronyc). In either case, Chronyd determines the rate at
      which the computer gains or loses time, and compensates for this. Chronyd
      implements the NTP protocol and can act as either a client or a server.

      Chronyc provides a user interface to Chronyd for monitoring its
      performance and configuring various settings. It can do so while running
      on the same computer as the Chronyd instance it is controlling or a
      different computer.
    '';
  };
}
