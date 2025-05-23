{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arcticons-sans";
  version = "0.592";

  src = fetchzip {
    hash = "sha256-fAEzLqFJ+3N6WSRvosk0R+JW1Gil+rEEzwHZgpDqSzE=";
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
