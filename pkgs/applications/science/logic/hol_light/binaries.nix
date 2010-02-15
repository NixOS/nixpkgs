{stdenv, ocaml_with_sources, hol_light, dmtcp, nettools, openssh}:
# nettools and openssh needed for dmtcp restarting script.

let
  selfcheckpoint_core_ml = ./selfcheckpoint_core.ml;
  selfcheckpoint_multivariate_ml = ./selfcheckpoint_multivariate.ml;
  selfcheckpoint_complex_ml = ./selfcheckpoint_complex.ml;
in

stdenv.mkDerivation {
  name = "hol_light_binaries-${hol_light.version}";

  buildInputs = [ dmtcp ocaml_with_sources nettools openssh];

  buildCommand = ''
    HOL_DIR=${hol_light}/src/hol_light
    BIN_DIR=$out/bin
    ensureDir $BIN_DIR

    # HOL Light Core
    dmtcp_coordinator --background
    echo 'Unix.system "dmtcp_command -k";;\n' |
      dmtcp_checkpoint -q -c "$BIN_DIR" \
        ocaml -I "$HOL_DIR" -init ${selfcheckpoint_core_ml}
    substituteInPlace dmtcp_restart_script.sh \
      --replace dmtcp_restart "dmtcp_restart --quiet"
    mv dmtcp_restart_script.sh $BIN_DIR/hol_light
    dmtcp_command -q

    # HOL Light Multivariate
    dmtcp_coordinator --background
    echo 'Unix.system "dmtcp_command -k";;\n' |
      dmtcp_checkpoint -q -c "$BIN_DIR" \
        ocaml -I "$HOL_DIR" -init ${selfcheckpoint_multivariate_ml}
    substituteInPlace dmtcp_restart_script.sh \
      --replace dmtcp_restart "dmtcp_restart --quiet"
    mv dmtcp_restart_script.sh $BIN_DIR/hol_light_multivariate
    dmtcp_command -q

    # HOL Light Complex
    dmtcp_coordinator --background
    echo 'Unix.system "dmtcp_command -k";;\n' |
      dmtcp_checkpoint -q -c "$BIN_DIR" \
        ocaml -I "$HOL_DIR" -init ${selfcheckpoint_complex_ml}
    substituteInPlace dmtcp_restart_script.sh \
      --replace dmtcp_restart "dmtcp_restart --quiet"
    mv dmtcp_restart_script.sh $BIN_DIR/hol_light_complex
    dmtcp_command -q
  '';

  meta = {
    description = "Preload binaries for HOL Light.";
    license = "BSD";
  };
}
