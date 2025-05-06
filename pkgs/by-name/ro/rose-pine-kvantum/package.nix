{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rose-pine-kvantum";
  version = "0-unstable-2025-03-26";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "kvantum";
    rev = "5a51f5892ba752088dee062a6188b9f0bb59324b";
    hash = "sha256-lUO3Bg9+KbPkllKu2sv9ueV1dcZu4qRn32N/+4+2B4A=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/Kvantum/themes
    for i in $(find . -iname "*.tar.gz"); do
        tar -xf $i -C $out/share/Kvantum/themes
    done

    runHook postInstall
  '';

  meta = {
    description = "Kvantum-themes based on Rose Pine";
    homepage = "https://github.com/rose-pine/kvantum";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ amadaluzia ];
    license = lib.licenses.unfree; # rose-pine/kvantum#1
  };
})
