{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sitelen-seli-kiwen";
  version = "1.8.1";

  src = fetchzip {
    url = "https://github.com/kreativekorp/sitelen-seli-kiwen/releases/download/${finalAttrs.version}/sitelenselikiwen.zip";
    stripRoot = false;
    hash = "sha256-FqhUsA+q3ZLfJRMxi47rz3FOWnm1pfXxWnM1c8HQ7NY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/{opentype,truetype}
    mv *.eot $out/share/fonts/opentype/
    mv *.ttf $out/share/fonts/truetype/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Handwritten sitelen pona font supporting UCSUR";
    homepage = "https://www.kreativekorp.com/software/fonts/sitelenselikiwen/";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ somasis ];
  };
})
