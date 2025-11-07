{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  symlinkJoin,
  alsa-ucm-conf,
}:
let
  alsa-ucm-conf-asahi = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "alsa-ucm-conf-asahi";
    version = "8";

    src = fetchFromGitHub {
      owner = "AsahiLinux";
      repo = "alsa-ucm-conf-asahi";
      tag = "v${finalAttrs.version}";
      hash = "sha256-FPrAzscc1ICSCQSqULaGLqG4UCq8GZU9XLV7TUSBBRM=";
    };

    installPhase = ''
      runHook preInstall

      find ucm2/conf.d -type f -exec install -Dm644 "{}" "$out/share/alsa/{}" \;

      runHook postInstall
    '';

    passthru = {
      updateScript = nix-update-script { };
    };

    meta = {
      description = "ALSA Use Case Manager configuration (and topologies) for Apple silicon devices";
      homepage = "https://github.com/AsahiLinux/alsa-ucm-conf-asahi";
      changelog = "https://github.com/AsahiLinux/alsa-ucm-conf-asahi/releases/tag/${finalAttrs.src.tag}";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ normalcea ];
      platforms = [ "aarch64-linux" ];
    };
  });
in
symlinkJoin {
  inherit (alsa-ucm-conf-asahi)
    pname
    version
    src
    passthru
    meta
    ;
  paths = [
    alsa-ucm-conf
    alsa-ucm-conf-asahi
  ];
}
