{
  coreutils,
  fetchurl,
  lib,
  nix-update-script,
  stdenvNoCC,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gnun";
  version = "1.5";

  src = fetchurl {
    url = "ftp://ftp.gnu.org/gnu/gnun/gnun-${finalAttrs.version}.tar.gz";
    hash = "sha256-xhgjT3XD1j5qLbTWEDm7uVvtePMoiebRBwwb1rYlGaM=";
  };

  postInstall = ''
    substituteInPlace $out/bin/${finalAttrs.meta.mainProgram} \
      --replace-fail cat ${lib.getExe' coreutils "cat"}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Build system for www.gnu.org translations";
    longDescription = ''
      GNUnited Nations (GNUN) is a build system for www.gnu.org
      translations.  It generates a PO template (.pot) for an original
      HTML article, and merges the changes into all translations,
      which are maintained as PO (.po) files.  Finally, it regenerates
      the translations in HTML format.

      The goal of GNUN is to make maintenance of gnu.org translations
      easier and to avoid the effect of seriously outdated
      translations when a particular team becomes inactive.

      GNUN is pretty much tied to the layout and structure of GNU
      Project's website and is not intended for use with other sites.

      The GNUN package also contains GNU Web Translators Manual.

      See also the trans-coord organizational project.
    '';
    homepage = "https://www.gnu.org/software/gnun";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gnun-link-diff";
    platforms = lib.platforms.all;
  };
})
