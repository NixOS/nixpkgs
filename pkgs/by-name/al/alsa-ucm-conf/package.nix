{
  directoryListingUpdater,
  fetchurl,
  lib,
  stdenvNoCC,
  coreutils,
  kmod,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alsa-ucm-conf";
  version = "1.2.16";

  src = fetchurl {
    url = "mirror://alsa/lib/alsa-ucm-conf-${finalAttrs.version}.tar.bz2";
    hash = "sha256-rLyXLW5x7fo0Xnav3xDDmf0PHzz5DYSv20z1G/xKZUg=";
  };

  patches = [

  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    substituteInPlace ucm2/lib/card-init.conf \
      --replace-fail "/bin/rm" "${coreutils}/bin/rm" \
      --replace-fail "/bin/mkdir" "${coreutils}/bin/mkdir"
  ''
  + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    substituteInPlace ucm2/common/ctl/led.conf \
      --replace-fail '/sbin/modprobe' '${kmod}/bin/modprobe'
  ''
  + ''

    mkdir -p $out/share/alsa
    cp -r ucm ucm2 $out/share/alsa

    runHook postInstall
  '';

  passthru.updateScript = directoryListingUpdater {
    url = "https://www.alsa-project.org/files/pub/lib/";
  };

  meta = {
    homepage = "https://www.alsa-project.org/";
    description = "ALSA Use Case Manager configuration";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      roastiek
      mvs
      nick-linux
    ];

    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
