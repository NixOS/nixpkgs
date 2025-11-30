{
  lib,
  stdenv,
  directoryListingUpdater,
  fetchurl,
  alsa-lib,
  alsa-plugins,
  gettext,
  makeWrapper,
  pkg-config,
  ncurses,
  libsamplerate,
  pciutils,
  procps,
  tree,
  which,
  fftw,
  pipewire,
  withPipewireLib ? true,
  symlinkJoin,
}:

let
  plugin-packages = [ alsa-plugins ] ++ lib.optional withPipewireLib pipewire;

  # Create a directory containing symlinks of all ALSA plugins.
  # This is necessary because ALSA_PLUGIN_DIR must reference only one directory.
  plugin-dir = symlinkJoin {
    name = "all-plugins";
    paths = map (path: "${path}/lib/alsa-lib") plugin-packages;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "alsa-utils";
  version = "1.2.14";

  src = fetchurl {
    url = "mirror://alsa/utils/alsa-utils-${finalAttrs.version}.tar.bz2";
    hash = "sha256-B5THTTP+2UPnxQYJwTCJ5AkxK2xAPWromE/EKcCWB0E=";
  };

  nativeBuildInputs = [
    gettext
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    ncurses
    libsamplerate
    fftw
  ];

  configureFlags = [
    "--disable-xmlto"
    "--with-udev-rules-dir=$(out)/lib/udev/rules.d"
  ];

  installFlags = [ "ASOUND_STATE_DIR=$(TMPDIR)/dummy" ];

  postFixup = ''
    mv $out/bin/alsa-info.sh $out/bin/alsa-info
    wrapProgram $out/bin/alsa-info --prefix PATH : "${
      lib.makeBinPath [
        which
        pciutils
        procps
        tree
      ]
    }" --prefix PATH : $out/bin
    for program in $out/bin/*; do
        wrapProgram "$program" --set-default ALSA_PLUGIN_DIR "${plugin-dir}"
    done
  '';

  postInstall = ''
    # udev rules are super broken, violating `udevadm verify` in various creative ways.
    # NixOS has its own set of alsa udev rules, we can just delete the udev rules for this package
    rm -rf $out/lib/udev
  '';

  passthru.updateScript = directoryListingUpdater {
    url = "https://www.alsa-project.org/files/pub/utils/";
  };

  meta = {
    homepage = "http://www.alsa-project.org/";
    description = "ALSA, the Advanced Linux Sound Architecture utils";
    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = with lib.licenses; [
      gpl2Plus
      gpl2Only # alsactl (init_{parse,sysdeps,sysfs,utils_{run,string}}.c, rest GPL 2.0+)
      lgpl21Plus # alsaucm
    ];

    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
