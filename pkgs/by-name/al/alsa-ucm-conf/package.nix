{
  directoryListingUpdater,
  fetchurl,
  fetchpatch,
  lib,
  stdenvNoCC,
  coreutils,
  kmod,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alsa-ucm-conf";
  version = "1.2.15.3";

  src = fetchurl {
    url = "mirror://alsa/lib/alsa-ucm-conf-${finalAttrs.version}.tar.bz2";
    hash = "sha256-n3noE8CPyGz6Rt11xPzaGkpRtILbJgfh/PqvuS9YijE=";
  };

  patches = [
    # fix for typo in 1.2.15.3 – remove with subsequent release
    (fetchpatch {
      url = "https://github.com/alsa-project/alsa-ucm-conf/commit/95377000e849259764f37295e0ddd58fd8a55a76.patch";
      hash = "sha256-o2qR69jiGXFWM0mxeIhXd+tCvGikYqnoalce1UOVppw=";
    })
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
    ];

    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
