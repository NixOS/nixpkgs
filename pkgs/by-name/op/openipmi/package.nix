{
  stdenv,
  buildPackages,
  fetchpatch,
  fetchurl,
  popt,
  ncurses,
  python3,
  readline,
  lib,
  nixosTests,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "OpenIPMI";
  version = "2.0.37";

  src = fetchurl {
    url = "mirror://sourceforge/openipmi/OpenIPMI-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-xi049dp99Cmaw6ZSUI6VlTd1JEAYHjTHayrs69fzAbk=";
  };

  patches = [
    # Fix broken command order in shipped ipmisim1:
    (fetchpatch {
      url = "https://github.com/cminyard/openipmi/commit/07adcedd824496d69be469101a7be1bbe371741a.patch";
      hash = "sha256-zAbnyliZr5HV9dYlyse4ff1lYJty+/74aqmXHWJM13c=";
    })

    # Sensors not marked ready after set_sensor_value.
    (fetchpatch {
      url = "https://github.com/cminyard/openipmi/commit/2325cc63727bab6a0f29fca2db4ba7d69c11e3b9.patch";
      hash = "sha256-ZbxV7ThFDbI5vxlLLavMrAZzCj3gPnR0sRcyHub5S30=";
    })
  ];

  postConfigure = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace lanserv/Makefile \
      --replace-fail "sdrcomp/sdrcomp_build -o" "${buildPackages.openipmi}/bin/sdrcomp -o"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    python3
  ];

  buildInputs = [
    ncurses
    popt
    python3
    readline
    openssl
  ];

  makeFlags = [
    "BUILD_CC=${stdenv.cc.targetPrefix}cc"
  ];

  # Include SDR files; ipmi-sim requires .bsdr (installed as sdr.20.main) to
  # advertise its sensor names.
  postInstall = ''
    install -Dm444 lanserv/ipmisim1.sdrs $out/share/openipmi/ipmisim1.sdrs
    install -Dm444 lanserv/ipmisim1.bsdr $out/share/openipmi/ipmisim1.bsdr
  '';

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) ipmi; };

  meta = {
    homepage = "https://openipmi.sourceforge.io/";
    description = "User-level library that provides a higher-level abstraction of IPMI and generic services";
    license = with lib.licenses; [
      gpl2Only
      lgpl2Only
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ arezvov ];
  };
})
