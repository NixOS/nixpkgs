{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  stateDir ? "/var/lib/dolibarr",
  # > Q: My PDF template doesn’t understand foreign characters, it outputs them
  # > as ???
  # >
  # > — https://wiki.dolibarr.org/index.php/Create_document_model#Q:_My_PDF_template_doesn't_understand_foreign_characters,_it_outputs_them_as_???
  #
  # Add fonts for generating PDFs (NOTE: the default only supports ASCII).
  #
  # Usage:
  #
  #   dolibarr.override {
  #     extraPDFFonts = { foofont = $DERVIATION_OR_PATH; };
  #   }
  #
  extraPDFFonts ? { },
}:

assert builtins.isAttrs extraPDFFonts;
assert lib.all (
  { name, value }:
  builtins.match "[a-z0-9_]+" name != null && (lib.isDerivation value || builtins.isPath value)
) (lib.attrsToList extraPDFFonts);

stdenv.mkDerivation (finalAttrs: {
  pname = "dolibarr";
  version = "24.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Dolibarr";
    repo = "dolibarr";
    tag = finalAttrs.version;
    hash = "sha256-gEMnl+OmOFfddvuHFrSMNYmQXfdybRefPX+5tMm+HDQ=";
  };

  dontBuild = true;

  postPatch = ''
    find . -type f -name "*.php" -print0 | xargs -0 sed -i 's|/etc/dolibarr|${stateDir}|g'

    substituteInPlace htdocs/filefunc.inc.php \
      --replace-fail '//$conffile = ' '$conffile = ' \
      --replace-fail '//$conffiletoshow = ' '$conffiletoshow = '

    substituteInPlace htdocs/install/inc.php \
      --replace-fail '//$conffile = ' '$conffile = ' \
      --replace-fail '//$conffiletoshow = ' '$conffiletoshow = '

    ${lib.optionalString (extraPDFFonts != { }) /* bash */ ''
      fonts_dir="htdocs/includes/tecnickcom/tcpdf/fonts"

      ${lib.concatMapAttrsStringSep "\n" (family: drvOrPath: /* bash */ ''
        if [ ! -f "${drvOrPath}/${family}.php" ]; then
          echo "extraPDFFonts.${family}: missing ${family}.php in derivation or path" >&2
          exit 1
        fi
        for f in "${drvOrPath}"/*; do
          ln -s "$f" "$fonts_dir/"
        done
      '') extraPDFFonts}
    ''}
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r * $out
  '';

  passthru.tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    inherit (nixosTests) dolibarr;
  };

  meta = {
    description = "Enterprise resource planning (ERP) and customer relationship manager (CRM) server";
    changelog = "https://github.com/Dolibarr/dolibarr/releases/tag/${finalAttrs.version}";
    homepage = "https://dolibarr.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
