{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arcticons-sans";
  version = "0.590";

  src = fetchzip {
    hash = "sha256-0iSkTfUMgrKi6LF+9KAihPus0biGuOFsYN51ydYAF5E=";
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
