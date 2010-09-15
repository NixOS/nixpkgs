{stdenv, writeTextFile, hol_light, dmtcp}:
let
  mkRestartScript = checkpointFile:
    let filename = "hol_light_${checkpointFile.variant}_dmtcp"; in
    writeTextFile {
      name = "${filename}-${hol_light.version}";
      destination = "/bin/${filename}";
      executable = true;
      text = ''
        #!/bin/sh
	exec ${dmtcp}/bin/dmtcp_restart --quiet ${checkpointFile}
      '';
    };

  mkCkptFile =
    { variant
    , banner
    , loads
    , startCkpt ? null
    , buildCommand ? ''
        cp ${startCkpt} hol_light_restart.ckpt
        (echo "$loadScript" | dmtcp_restart --quiet hol_light_restart.ckpt) || exit 0
        cp hol_light_restart.ckpt $out
      ''
    }:
    stdenv.mkDerivation rec {
      name = "hol_light_${variant}_dmtcp.checkpoint-${hol_light.version}";
      inherit variant banner buildCommand;
      buildInputs = [ dmtcp hol_light ];
      loadScript = ''
        ${loads}
        dmtcp_checkpoint "${banner}";;
      '';
    };
in
rec {
  hol_light_core_dmtcp = mkRestartScript hol_light_core_dmtcp_ckpt;
  hol_light_sosa_dmtcp = mkRestartScript hol_light_sosa_dmtcp_ckpt;
  hol_light_card_dmtcp = mkRestartScript hol_light_card_dmtcp_ckpt;
  hol_light_multivariate_dmtcp = mkRestartScript hol_light_multivariate_dmtcp_ckpt;
  hol_light_complex_dmtcp = mkRestartScript hol_light_complex_dmtcp_ckpt;

  hol_light_core_dmtcp_ckpt = mkCkptFile rec {
    variant = "core";
    banner = "";
    loads = ''
      #use "${./dmtcp_selfdestruct.ml}";;
    '';
    buildCommand = ''
      (echo "$loadScript" | dmtcp_checkpoint --quiet ${hol_light}/bin/start_hol_light) || exit 0
      mv ckpt* $out
    '';
  };

  hol_light_multivariate_dmtcp_ckpt = mkCkptFile {
    variant = "multivariate";
    banner = "Preloaded with multivariate analysis";
    loads = ''
      loadt "Multivariate/make.ml";;
    '';
    startCkpt = hol_light_core_dmtcp_ckpt;
  };

  hol_light_sosa_dmtcp_ckpt = mkCkptFile {
    variant = "sosa";
    banner = "Preloaded with analysis and SOS";
    loads = ''
      loadt "Library/analysis.ml";;
      loadt "Library/transc.ml";;
      loadt "Examples/sos.ml";;
      loadt "update_database.ml";;
    '';
    startCkpt = hol_light_core_dmtcp_ckpt;
  };

  hol_light_card_dmtcp_ckpt = mkCkptFile {
    variant = "card";
    banner = "Preloaded with cardinal arithmetic";
    loads = ''
      loadt "Library/card.ml";;
      loadt "update_database.ml";;
    '';
    startCkpt = hol_light_core_dmtcp_ckpt;
  };

  hol_light_complex_dmtcp_ckpt = mkCkptFile {
    variant = "complex";
    banner = "Preloaded with multivariate-based complex analysis";
    loads = ''
      loadt "Multivariate/complexes.ml";;
      loadt "Multivariate/canal.ml";;
      loadt "Multivariate/transcendentals.ml";;
      loadt "Multivariate/realanalysis.ml";;
      loadt "Multivariate/cauchy.ml";;
      loadt "Multivariate/complex_database.ml";;
    '';
    startCkpt = hol_light_multivariate_dmtcp_ckpt;
  };
}
