{
  stdenvNoCC,
  installFonts,
  gnugrep,
  writeTextFile,
  lib,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "isabelle-fonts";
  version = "20241227";

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/isabelle_fonts-${finalAttrs.version}.tar.gz";
    hash = "sha256-76q3MhOhpvN54yO6XUpV4t4Q/TPhJK8rtGneg+puIXc=";
  };

  dontInstallFonts = true;

  nativeBuildInputs = [
    installFonts
  ];

  installPhase = ''
    runHook preInstall

    pushd ttf
    installFont ttf "$out/share/fonts/truetype"
    popd

    pushd ttf-hinted
    installFont ttf "$out/share/fonts/truetype/hinted"
    popd

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "isabelle-fonts-settings";
    text = ''
      if ${lib.getExe' gnugrep "grep"} "isabelle_fonts_hinted.*=.*false" "$ISABELLE_HOME_USER/etc/preferences" >/dev/null 2>/dev/null
      then
        isabelle_fonts \
          "${finalAttrs.finalPackage}/share/fonts/truetype/IsabelleDejaVuSansMono.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/IsabelleDejaVuSansMono-Bold.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/IsabelleDejaVuSansMono-Oblique.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/IsabelleDejaVuSansMono-BoldOblique.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/IsabelleDejaVuSans.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/IsabelleDejaVuSans-Bold.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/IsabelleDejaVuSans-Oblique.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/IsabelleDejaVuSans-BoldOblique.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/IsabelleDejaVuSerif.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/IsabelleDejaVuSerif-Bold.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/IsabelleDejaVuSerif-Italic.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/IsabelleDejaVuSerif-BoldItalic.ttf"
      else
        isabelle_fonts \
          "${finalAttrs.finalPackage}/share/fonts/truetype/hinted/IsabelleDejaVuSansMono.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/hinted/IsabelleDejaVuSansMono-Bold.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/hinted/IsabelleDejaVuSansMono-Oblique.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/hinted/IsabelleDejaVuSansMono-BoldOblique.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/hinted/IsabelleDejaVuSans.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/hinted/IsabelleDejaVuSans-Bold.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/hinted/IsabelleDejaVuSans-Oblique.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/hinted/IsabelleDejaVuSans-BoldOblique.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/hinted/IsabelleDejaVuSerif.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/hinted/IsabelleDejaVuSerif-Bold.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/hinted/IsabelleDejaVuSerif-Italic.ttf" \
          "${finalAttrs.finalPackage}/share/fonts/truetype/hinted/IsabelleDejaVuSerif-BoldItalic.ttf"
      fi

      isabelle_fonts_hidden "${finalAttrs.finalPackage}/share/fonts/truetype/Vacuous.ttf"
    '';
    destination = "/etc/settings";
  };

  meta = {
    description = "DejaVu font with extra symbols for Isabelle";
    homepage = "https://isabelle.in.tum.de/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    platforms = lib.platforms.all;
  };
})
