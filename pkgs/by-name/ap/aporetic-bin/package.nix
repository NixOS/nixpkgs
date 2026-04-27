{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aporetic-bin";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "protesilaos";
    repo = "aporetic";
    tag = finalAttrs.version;
    hash = "sha256-1BbuC/mWEcXJxzDppvsukhNtdOLz0QosD6QqI/93Khc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp -r $src/{aporetic-sans-mono,aporetic-sans,aporetic-serif-mono,aporetic-serif} $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/protesilaos/aporetic";
    description = ''
      Custom build of Iosevka with different style and metrics than the default. This is the successor to my "Iosevka Comfy" fonts.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      DamienCassou
    ];
  };
})
