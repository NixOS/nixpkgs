{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  alsa-topology-conf,
  alsa-ucm-conf,
  testers,
  directoryListingUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alsa-lib";
  version = "1.2.16.1";

  src = fetchurl {
    url = "mirror://alsa/lib/alsa-lib-${finalAttrs.version}.tar.bz2";
    hash = "sha256-90Dbf0iCVZRP/UQoQW7jOQqWdChWkWQz30aMKBQ2SA4=";
  };

  patches = [
    # Add a "libs" field to the syntax recognized in the /etc/asound.conf file.
    # The nixos modules for pulseaudio, jack, and pipewire are leveraging this
    # "libs" field to declare locations for both native and 32bit plugins, in
    # order to support apps with 32bit sound running on x86_64 architecture.
    ./alsa-plugin-conf-multilib.patch
    (fetchpatch {
      name = "CVE-2026-90781-numid-overrun.patch";
      url = "https://github.com/alsa-project/alsa-lib/commit/1e27d63ef6d1dcf7d1f1a1e1eca3ea779e7de377.patch";
      hash = "sha256-RKccQvYL7KvkUBmbYM8Cyw3Noiqoy3HXHlhmWAI36mk=";
    })
    (fetchpatch {
      name = "CVE-2026-90781.patch";
      url = "https://github.com/alsa-project/alsa-lib/commit/f84cd4ced7b36fddb8e4ee24404cf7c091d27020.patch";
      hash = "sha256-j6PDznimtrHO/phRJ9p3aKrjG85BRpuDOhdhhATJqe8=";
    })
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
    changelog = "https://github.com/alsa-project/alsa-lib/releases/tag/v${finalAttrs.version}";
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
    maintainers = with lib.maintainers; [
      nick-linux
    ];
  };
})
