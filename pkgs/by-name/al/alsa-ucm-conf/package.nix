{
  nix-update-script,
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  coreutils,
  kmod,
  alsa-lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alsa-ucm-conf";
  version = "1.2.13-unstable-2025-03-21";

  src = fetchFromGitHub {
    owner = "alsa-project";
    repo = "alsa-ucm-conf";
    rev = "28c5875e564a80b778ba375efddfef2b58d724a3";
    hash = "sha256-NPdrSKJNP90sFQ/UAvJgXoDMnrWXcyq3qYfd1Tqgqko=";
  };

  dontBuild = true;

  installPhase =
    ''
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

  passthru = {
    tests = { inherit alsa-lib; };
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
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
