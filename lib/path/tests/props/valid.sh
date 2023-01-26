stage_setup 1000

stage_awk_expr \
  input 'gen_subpath()' \
  expected_valid 'subpath_is_valid(input) ? "true" : "false"'

stage_nix_expr valid 'lib.boolToString (lib.path.subpath.isValid input)'

stage_check valid == expected_valid
