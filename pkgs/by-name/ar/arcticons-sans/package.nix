{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arcticons-sans";
  version = "0.580";

  src = fetchzip {
    hash = "sha256-BRyYHOuz7zxD1zD4L4DmI9dFhGePmGFDqYmS0DIbvi8=";
    url = "https://github.com/arcticons-team/arcticons-font/archive/refs/tags/${finalAttrs.version}.zip";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    description = "Arcticons Sans";
    homepage = "https://github.com/arcticons-team/arcticons-font";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ asininemonkey ];
  };
})
