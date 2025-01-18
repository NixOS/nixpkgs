{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arcticons-sans";
  version = "0.591";

  src = fetchzip {
    hash = "sha256-fMsAvrH4NVdXoywW66fJhNWDDY5JxDxPJgvaUD9lEpw=";
    url = "https://github.com/arcticons-team/arcticons-font/archive/refs/tags/${finalAttrs.version}.zip";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Arcticons Sans";
    homepage = "https://github.com/arcticons-team/arcticons-font";
    license = licenses.ofl;
    maintainers = with maintainers; [ asininemonkey ];
  };
})
