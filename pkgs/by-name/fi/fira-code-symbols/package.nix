{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "fira-code-symbols";
  version = "20160811";

  src = fetchzip {
    url = "https://github.com/tonsky/FiraCode/files/412440/FiraCode-Regular-Symbol.zip";
    hash = "sha256-7y51blEn0Osf8azytK08zJgtfVX/CIWQkiOoRzYKIa4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    description = "FiraCode unicode ligature glyphs in private use area";
    longDescription = ''
      FiraCode uses ligatures, which some editors don’t support.
      This addition adds them as glyphs to the private unicode use area.
      See https://github.com/tonsky/FiraCode/issues/211.
    '';
    license = licenses.ofl;
    maintainers = [ ];
    homepage = "https://github.com/tonsky/FiraCode/issues/211#issuecomment-239058632";
  };
}
