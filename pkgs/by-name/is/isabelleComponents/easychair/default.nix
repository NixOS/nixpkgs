{
  lib,
  stdenvNoCC,
  fetchzip,
  writeTextFile,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "easychair";
  version = "3.5";

  src = fetchzip {
    url = "https://easychair.org/publications/easychair.zip";
    hash = "sha256-lgkuO1i6iS0oLuxn1EahV3MvMS9bKYSgZ9jVcHwdfSA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/easychair
    cp ./* $out/share/easychair

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "easychair-settings";
    text = ''
      ISABELLE_EASYCHAIR_HOME="${finalAttrs.finalPackage}/share/easychair"
    '';
    destination = "/etc/settings";
  };

  meta = {
    description = "Easychair LaTeX style for authors";
    homepage = "https://easychair.org/publications";
    license = lib.licenses.free;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    platforms = lib.platforms.all;
  };
})
