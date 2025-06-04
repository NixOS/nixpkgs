{
  directoryListingUpdater,
  fetchurl,
  lib,
  stdenv,
  coreutils,
  kmod,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alsa-ucm-conf";
  version = "1.2.12";

  src = fetchurl {
    url = "mirror://alsa/lib/alsa-ucm-conf-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Fo58BUm3v4mRCS+iv7kDYx33edxMQ+6PQnf8t3LYwDU=";
  };

  dontBuild = true;

  installPhase =
    ''
      runHook preInstall

      substituteInPlace ucm2/lib/card-init.conf \
        --replace-fail "/bin/rm" "${coreutils}/bin/rm" \
        --replace-fail "/bin/mkdir" "${coreutils}/bin/mkdir"

      files=(
          "ucm2/HDA/HDA.conf"
          "ucm2/codecs/rt715/init.conf"
          "ucm2/codecs/rt715-sdca/init.conf"
          "ucm2/Intel/cht-bsw-rt5672/cht-bsw-rt5672.conf"
          "ucm2/Intel/bytcr-rt5640/bytcr-rt5640.conf"
      )

    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      for file in "''${files[@]}"; do
          substituteInPlace "$file" \
              --replace-fail '/sbin/modprobe' '${kmod}/bin/modprobe'
      done
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
    maintainers = [ lib.maintainers.roastiek ];
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
