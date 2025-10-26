{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  libpcap,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iftop";
  version = "1.0pre4";

  src = fetchurl {
    url = "http://ex-parrot.com/pdw/iftop/download/iftop-${finalAttrs.version}.tar.gz";
    sha256 = "15sgkdyijb7vbxpxjavh5qm5nvyii3fqcg9mzvw7fx8s6zmfwczp";
  };

  patches = [
    # Fix build with gcc 15
    (fetchurl {
      url = "https://salsa.debian.org/debian/iftop/-/raw/750d49dd3fabc338586a86f5bb0a5b97a5ff5fa2/debian/patches/bug-debian-1096832-ftbfs-with-GCC-15.patch";
      hash = "sha256-BhjN7AZNCJCqrY2IAutUYYDZkLq+TD2YnKYZxHgVdYg=";
    })
  ];

  # Explicitly link against libgcc_s, to work around the infamous
  # "libgcc_s.so.1 must be installed for pthread_cancel to work".
  env.LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux "-lgcc_s";

  buildInputs = [
    ncurses
    libpcap
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: tui.o:/build/iftop-1.0pre4/ui_common.h:41: multiple definition of `service_hash';
  #     iftop.o:/build/iftop-1.0pre4/ui_common.h:41: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  passthru.tests = { inherit (nixosTests) iftop; };

  meta = {
    description = "Display bandwidth usage on a network interface";
    longDescription = ''
      iftop does for network usage what top(1) does for CPU usage. It listens
      to network traffic on a named interface and displays a table of current
      bandwidth usage by pairs of hosts.
    '';
    license = lib.licenses.gpl2Plus;
    homepage = "http://ex-parrot.com/pdw/iftop/";
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "iftop";
  };
})
