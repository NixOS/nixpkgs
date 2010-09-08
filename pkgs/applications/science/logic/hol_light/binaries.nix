{stdenv, hol_light, dmtcp}:

let
  cmd_core = ''
    #use "${./start_hol.ml}";;
    dmtcp_selfdestruct "";;
  '';
  cmd_multivariate = ''
    loadt "Multivariate/make.ml";;
    dmtcp_checkpoint "Preloaded with multivariate analysis";;
  '';
  cmd_complex = ''
    loadt "Multivariate/complexes.ml";;
    loadt "Multivariate/canal.ml";;
    loadt "Multivariate/transcendentals.ml";;
    loadt "Multivariate/realanalysis.ml";;
    loadt "Multivariate/cauchy.ml";;
    loadt "Multivariate/complex_database.ml";;
    loadt "update_database.ml";;
    dmtcp_checkpoint "Preloaded with multivariate-based complex analysis";;
  '';
in

stdenv.mkDerivation {
  name = "hol_light_binaries-${hol_light.version}";

  buildInputs = [ dmtcp hol_light hol_light.ocaml ];

  buildCommand = ''
    HOL_DIR="${hol_light}/src/hol_light"
    BIN_DIR="$out/bin"
    ensureDir "$BIN_DIR"

    # HOL Light Core
    (echo '${cmd_core}' | dmtcp_checkpoint --quiet ${hol_light}/bin/start_hol_light) || exit 0
    mv ckpt* "$BIN_DIR/hol_light.ckpt"
    substitute "${./restart_hol_light}" "$BIN_DIR/hol_light" \
      --subst-var-by DMTCP_RESTART `type -p dmtcp_restart` \
      --subst-var-by CKPT_FILE "$BIN_DIR/hol_light.ckpt"
    chmod +x "$BIN_DIR/hol_light"

    # HOL Light Multivariate
    cp "$BIN_DIR/hol_light.ckpt" .
    (echo '${cmd_multivariate}' | dmtcp_restart --quiet hol_light.ckpt) || exit 0
    mv hol_light.ckpt "$BIN_DIR/hol_light_multivariate.ckpt"
    substitute "${./restart_hol_light}" "$BIN_DIR/hol_light_multivariate" \
      --subst-var-by DMTCP_RESTART `type -p dmtcp_restart` \
      --subst-var-by CKPT_FILE "$BIN_DIR/hol_light_multivariate.ckpt"
    chmod +x "$BIN_DIR/hol_light_multivariate"

    # HOL Light Complex
    cp "$BIN_DIR/hol_light_multivariate.ckpt" .
    (echo '${cmd_complex}' | dmtcp_restart --quiet hol_light_multivariate.ckpt) || exit 0
    mv hol_light_multivariate.ckpt "$BIN_DIR/hol_light_complex.ckpt"
    substitute "${./restart_hol_light}" "$BIN_DIR/hol_light_complex" \
      --subst-var-by DMTCP_RESTART `type -p dmtcp_restart` \
      --subst-var-by CKPT_FILE "$BIN_DIR/hol_light_complex.ckpt"
    chmod +x "$BIN_DIR/hol_light_complex"
  '';
}
