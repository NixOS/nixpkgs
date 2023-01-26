stage_setup 1000
stage_awk_expr \
  a 'gen_subpath_with("valid", 5)' \
  b 'gen_subpath_with("valid", 5)'

stage_nix_expr a_normalised 'lib.path.subpath.normalise a'
stage_nix_expr b_normalised 'lib.path.subpath.normalise b'
stage_condition a_normalised != b_normalised

stage_bash_expr a_realpath 'realpath -m --relative-to=$PWD -- "$a"'
stage_bash_expr b_realpath 'realpath -m --relative-to=$PWD -- "$b"'

stage_check a_realpath != b_realpath
