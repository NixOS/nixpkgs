{
  coreutils,
  diffutils,
  directoryListingUpdater,
  fetchurl,
  findutils,
  gettext,
  gnugrep,
  lib,
  libxml2,
  po4a,
  stdenvNoCC,
  versionCheckHook,
  wdiff,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gnun";
  version = "1.6";

  src = fetchurl {
    url = "mirror://gnu/gnun/gnun-${finalAttrs.version}.tar.gz";
    hash = "sha256-fXS4VP/71ypZrSjRnHjyNZ5u/5ITY+JMeCqJtPxc5NY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  # Configure records absolute paths to these programs in the installed
  # scripts and config.mk, and enables the matching features only when it
  # finds them.
  nativeBuildInputs = [
    gettext
    libxml2
    po4a
    wdiff
  ];

  # Install the bundled XHTML DTDs, which gnun-validate-html needs with
  # --nonet.  The probe for system DTDs passes in the sandbox because
  # xmllint exits with status 0 when it cannot load the DTD.
  #
  # Make GNUmakefile run msgcat and sed through the absolute paths in
  # config.mk, as it does elsewhere, instead of from the user's PATH.
  postPatch = ''
    substituteInPlace configure \
      --replace-fail "  have_dtds=yes" "  have_dtds=no"
    substituteInPlace GNUmakefile \
      --replace-fail "msgcat --use-first" "\$(MSGCAT) --use-first" \
      --replace-fail "| sed '" "| \$(SED) '"
  '';

  # Configure never substitutes VALIDATE_FLAGS, so the literal placeholder
  # would end up in config.mk and break validate-html-notify.
  makeFlags = [ "VALIDATE_FLAGS=" ];

  # Prepend the runtime PATH inside the scripts instead of wrapping them,
  # since they print $0 into their output, and export it from config.mk
  # for the recipes in GNUmakefile.  Diffutils is for wdiff, which runs
  # diff from PATH, gettext is for po4a, which runs msgfmt and msgmerge
  # from PATH, and gnugrep is for gnun-init-po.
  postInstall =
    let
      runtimePath = lib.makeBinPath [
        coreutils
        diffutils
        findutils
        gettext
        gnugrep
      ];
    in
    ''
      for script in $out/bin/* $out/libexec/gnun/{mailfail,update-localized-urls,validate-html-notify}; do
        sed -i "1a export PATH=${runtimePath}\''${PATH:+:}\$PATH" "$script"
      done
      echo 'export PATH := ${runtimePath}$(if $(PATH),:$(PATH))' >> $out/share/gnun/config.mk
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = directoryListingUpdater {
    url = "https://ftp.gnu.org/gnu/gnun/";
  };

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
    license = with lib.licenses; [
      gpl3Plus
      fdl13Plus
      # Bundled XHTML DTDs
      w3c-19980720
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gnun-link-diff";
    platforms = lib.platforms.all;
  };
})
