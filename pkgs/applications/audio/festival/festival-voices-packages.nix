{
  lib,
  stdenv,
  newScope,
}:

lib.makeScope newScope (self: {

  buildFestivalVoice = self.callPackage ./build-festival-voice.nix {
    inherit lib stdenv;
  };

  # All voices must have the same name as in festival
  # echo '(mapcar (lambda (v) (format t "%s\n" v)) (voice.list))' | festival 2>/dev/null | grep -E '^[a-zA-Z0-9_]+$'

  # US English voices (CMU)
  cmu_us_aew_cg = self.callPackage ./voices/cmu_us_aew_cg { };
  cmu_us_ahw_cg = self.callPackage ./voices/cmu_us_ahw_cg { };
  cmu_us_aup_cg = self.callPackage ./voices/cmu_us_aup_cg { };
  cmu_us_awb_cg = self.callPackage ./voices/cmu_us_awb_cg { };
  cmu_us_axb_cg = self.callPackage ./voices/cmu_us_axb_cg { };
  cmu_us_bdl_cg = self.callPackage ./voices/cmu_us_bdl_cg { };
  cmu_us_clb_cg = self.callPackage ./voices/cmu_us_clb_cg { };
  cmu_us_eey_cg = self.callPackage ./voices/cmu_us_eey_cg { };
  cmu_us_fem_cg = self.callPackage ./voices/cmu_us_fem_cg { };
  cmu_us_gka_cg = self.callPackage ./voices/cmu_us_gka_cg { };
  cmu_us_jmk_cg = self.callPackage ./voices/cmu_us_jmk_cg { };
  cmu_us_ksp_cg = self.callPackage ./voices/cmu_us_ksp_cg { };
  cmu_us_ljm_cg = self.callPackage ./voices/cmu_us_ljm_cg { };
  cmu_us_lnh_cg = self.callPackage ./voices/cmu_us_lnh_cg { };
  cmu_us_rms_cg = self.callPackage ./voices/cmu_us_rms_cg { };
  cmu_us_rxr_cg = self.callPackage ./voices/cmu_us_rxr_cg { };
  cmu_us_slp_cg = self.callPackage ./voices/cmu_us_slp_cg { };
  cmu_us_slt_cg = self.callPackage ./voices/cmu_us_slt_cg { };
  kal_diphone = self.callPackage ./voices/kal_diphone { };

  # Indian
  cmu_indic_ben_rm_cg = self.callPackage ./voices/cmu_indic_ben_rm_cg { };
  cmu_indic_guj_ad_cg = self.callPackage ./voices/cmu_indic_guj_ad_cg { };
  cmu_indic_guj_dp_cg = self.callPackage ./voices/cmu_indic_guj_dp_cg { };
  cmu_indic_guj_kt_cg = self.callPackage ./voices/cmu_indic_guj_kt_cg { };
  cmu_indic_hin_ab_cg = self.callPackage ./voices/cmu_indic_hin_ab_cg { };
  cmu_indic_kan_plv_cg = self.callPackage ./voices/cmu_indic_kan_plv_cg { };
  cmu_indic_mar_aup_cg = self.callPackage ./voices/cmu_indic_mar_aup_cg { };
  cmu_indic_mar_slp_cg = self.callPackage ./voices/cmu_indic_mar_slp_cg { };
  cmu_indic_pan_amp_cg = self.callPackage ./voices/cmu_indic_pan_amp_cg { };
  cmu_indic_tam_sdr_cg = self.callPackage ./voices/cmu_indic_tam_sdr_cg { };
  cmu_indic_tel_kpn_cg = self.callPackage ./voices/cmu_indic_tel_kpn_cg { };
  cmu_indic_tel_sk_cg = self.callPackage ./voices/cmu_indic_tel_sk_cg { };
  cmu_indic_tel_ss_cg = self.callPackage ./voices/cmu_indic_tel_ss_cg { };

  # English (GB)
  rab_diphone = self.callPackage ./voices/rab_diphone { };
})
