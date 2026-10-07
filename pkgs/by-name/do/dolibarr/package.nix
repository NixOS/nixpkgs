{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  php,
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
  #     extraPDFFonts =
  #       { foofont = $DERVIATION_OR_PATH; }
  #       // dolibarr.mkTCPDFFont { name = "freesans"; src = pkgs.freefont_ttf; findFilePrefix = "FreeSans"; };
  #   }
  #
  extraPDFFonts ? { },
}:

assert builtins.isAttrs extraPDFFonts;
assert lib.all (
  { name, value }:
  builtins.match "[a-z0-9_]+" name != null
  && builtins.isAttrs value
  && (lib.isDerivation value.src || builtins.isPath value.src)
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
          ln -sfn "$f" "$fonts_dir/"
        done
      '') extraPDFFonts}
    ''}
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r * $out
  '';

  passthru = {
    mkTCPDFFont =
      {
        name,
        src,
        findFilePrefix ? "-",
      }:
      {
        ${name} = runCommand "TCPDF-font-${name}" { nativeBuildInputs = [ php ]; } ''
          set -eu -o pipefail

          # All found TTF files
          candidates=$(find "${src}" -type f -iname "*${findFilePrefix}*.ttf" | sort || true)
          # Dashless italic/oblique lookups must not resolve to bold variants
          # (such as “*BoldItalic.ttf”)
          candidates_no_bold=$(printf '%s\n' "$candidates" | grep -vi -E "bold(italic|oblique)" || true)
          # Bare stem for families whose regular face carries no variant token
          # (such as “FreeSans.ttf”)
          bare_prefix=$(printf '%s' "${findFilePrefix}" | sed 's/[-_ ]$//')

          # Tokens are regex fragments matched against the candidate list
          # (case-insensitive); the first token with a hit wins (top sorted hit).
          pick_ttf_from() {
            local list="$1"
            shift
            local token hit
            for token in "$@"; do
              hit=$(printf '%s\n' "$list" | grep -i -E "$token" | head -n1 || true)
              if [ -n "$hit" ]; then
                printf '%s\n' "$hit"
                return 0
              fi
            done
            return 0
          }

          mkdir -p "$out"

          regular=$(pick_ttf_from "$candidates" "[-_]?[Rr]egular\.ttf$")
          if [ -z "$regular" ] && [ -n "$bare_prefix" ]; then
            regular=$(printf '%s\n' "$candidates" | grep -i -F "/$bare_prefix.ttf" | head -n1 || true)
          fi
          if [ -n "$regular" ]; then
            cp "$regular" "$out/${name}.ttf"
          else
            echo "No matching Regular TTF file for “${name}” to create a TCPDF font" >&2
            exit 1
          fi

          bold=$(pick_ttf_from "$candidates" "[-_]?[Bb]old\.ttf$")
          if [ -n "$bold" ]; then
            cp "$bold" "$out/${name}b.ttf"
          fi

          italic=$(pick_ttf_from "$candidates_no_bold" "[-_]?[Ii]talic\.ttf$" "[-_]?[Oo]blique\.ttf$")
          if [ -n "$italic" ]; then
            cp "$italic" "$out/${name}i.ttf"
          fi

          bold_italic=$(pick_ttf_from "$candidates" "[-_]?[Bb]old[Ii]talic\.ttf$" "[-_]?[Bb]old[Oo]blique\.ttf$")
          if [ -n "$bold_italic" ]; then
            cp "$bold_italic" "$out/${name}bi.ttf"
          fi

          for ttf in "$out"/*.ttf; do
            php -r '${/* php */ ''
              require "${finalAttrs.src}/htdocs/includes/tecnickcom/tcpdf/include/tcpdf_font_data.php";
              require "${finalAttrs.src}/htdocs/includes/tecnickcom/tcpdf/include/tcpdf_static.php";
              require "${finalAttrs.src}/htdocs/includes/tecnickcom/tcpdf/include/tcpdf_fonts.php";
              $font = TCPDF_FONTS::addTTFfont($argv[1], "TrueTypeUnicode", "", 32, $argv[2], 3, 1, false, false);
              exit($font ? 0 : 1);
            ''}' -- "$ttf" "$out/"
          done
        '';
      };

    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) dolibarr;
    };
  };

  meta = {
    description = "Enterprise resource planning (ERP) and customer relationship manager (CRM) server";
    changelog = "https://github.com/Dolibarr/dolibarr/releases/tag/${finalAttrs.version}";
    homepage = "https://dolibarr.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
