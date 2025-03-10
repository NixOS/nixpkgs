{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  alsa-topology-conf,
  alsa-ucm-conf,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alsa-lib";
  version = "1.2.13";

  src = fetchurl {
    url = "mirror://alsa/lib/alsa-lib-${finalAttrs.version}.tar.bz2";
    hash = "sha256-jE/zdVPL6JYY4Yfkx3n3GpuyqLJ7kfh+1AmHzJIz2PY=";
  };

  patches =
    [
      # Add a "libs" field to the syntax recognized in the /etc/asound.conf file.
      # The nixos modules for pulseaudio, jack, and pipewire are leveraging this
      # "libs" field to declare locations for both native and 32bit plugins, in
      # order to support apps with 32bit sound running on x86_64 architecture.
      ./alsa-plugin-conf-multilib.patch
    ]
    ++ lib.optional (stdenv.hostPlatform.useLLVM or false)
      # Fixes version script under LLVM, should be fixed in the next update.
      # Check if "pkgsLLVM.alsa-lib" builds on next version bump and remove this
      # if it succeeds.
      (
        fetchurl {
          url = "https://github.com/alsa-project/alsa-lib/commit/76edab4e595bd5f3f4c636cccc8d7976d3c519d6.patch";
          hash = "sha256-WCOXfe0/PPZRMXdNa29Jn28S2r0PQ7iTsabsxZVSwnk=";
        }
      );

  enableParallelBuilding = true;

  postInstall = ''
    ln -s ${alsa-ucm-conf}/share/alsa/{ucm,ucm2} $out/share/alsa
    ln -s ${alsa-topology-conf}/share/alsa/topology $out/share/alsa
  '';

  outputs = [
    "out"
    "dev"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    homepage = "http://www.alsa-project.org/";
    description = "ALSA, the Advanced Linux Sound Architecture libraries";
    mainProgram = "aserver";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.lgpl21Plus;
    pkgConfigModules = [
      "alsa"
      "alsa-topology"
    ];
    platforms = platforms.linux ++ platforms.freebsd;
    maintainers = with maintainers; [ l-as ];
  };
})
