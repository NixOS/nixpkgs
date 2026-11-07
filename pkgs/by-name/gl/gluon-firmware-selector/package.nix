{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gluon-firmware-selector";

  version = "0-unstable-2025-10-19";

  src = fetchFromGitHub {
    owner = "freifunk-darmstadt";
    repo = "gluon-firmware-selector";
    rev = "91dfdb813cb08bfaaf62eb90ad2a61386d95cdbd";
    sha256 = "sha256-9+mwaNq/M8wIrwUydQVIunZzledF+wTPJrwYOCf881s=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/${finalAttrs.pname}
    cp -r $src/*{.js,.html,.css,router.png} $out/share/${finalAttrs.pname}/
    echo "VERSION=${finalAttrs.version}" > $out/share/${finalAttrs.pname}/version.txt
    echo "REV=${finalAttrs.src.rev}" >> $out/share/${finalAttrs.pname}/version.txt
  '';

  meta = {
    description = "Firmware selector for gluon router images";
    homepage = "https://github.com/freifunk-darmstadt/gluon-firmware-selector";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    license = lib.licenses.agpl3Only;
  };
})
