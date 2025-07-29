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
  version = "1.2.14-unstable-2025-06-24";

  src = fetchFromGitHub {
    owner = "alsa-project";
    repo = "alsa-ucm-conf";
    rev = "1b69ade9b6d7ee37a87c08b12d7955d0b68fa69d";
    hash = "sha256-7PxI1/vQhrYOneNNRQI1vflPLqfd/ug1MorsZSQ5B3U=";
  };

  dontBuild = true;
  doInstallCheck = true;

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

  installCheckPhase = ''
    runHook preInstallCheck

    if grep -E -r '\<exec\>\s+"-?/s?bin/' "$out"; then
      echo found at least one unattended exec directive >&2
      exit 1
    fi

    runHook postInstallCheck
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
    maintainers = with lib.maintainers; [
      roastiek
      mvs
    ];

    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
