{
  lib,
  stdenv,
  fetchurl,
  alsa-topology-conf,
  alsa-ucm-conf,
  testers,
  directoryListingUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alsa-lib";
  version = "1.2.14";

  src = fetchurl {
    url = "mirror://alsa/lib/alsa-lib-${finalAttrs.version}.tar.bz2";
    hash = "sha256-vpyIoLNgQ2fddBZ6K3VKNeFC9nApKuR6L97yei7pejI=";
  };

  patches = [
    # Add a "libs" field to the syntax recognized in the /etc/asound.conf file.
    # The nixos modules for pulseaudio, jack, and pipewire are leveraging this
    # "libs" field to declare locations for both native and 32bit plugins, in
    # order to support apps with 32bit sound running on x86_64 architecture.
    ./alsa-plugin-conf-multilib.patch
  ];

  enableParallelBuilding = true;

  postInstall = ''
    ln -s ${alsa-ucm-conf}/share/alsa/{ucm,ucm2} $out/share/alsa
    ln -s ${alsa-topology-conf}/share/alsa/topology $out/share/alsa
  '';

  outputs = [
    "out"
    "dev"
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = directoryListingUpdater {
      url = "https://www.alsa-project.org/files/pub/lib/";
    };
  };

  meta = {
    homepage = "http://www.alsa-project.org/";
    description = "ALSA, the Advanced Linux Sound Architecture libraries";
    mainProgram = "aserver";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = lib.licenses.lgpl21Plus;
    pkgConfigModules = [
      "alsa"
      "alsa-topology"
    ];
    platforms = with lib.platforms; linux ++ freebsd;
    maintainers = [ ];
  };
})
