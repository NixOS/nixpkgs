stage_setup 1000
stage_awk_expr \
    subpath 'gen_subpath()' \
    valid 'subpath_is_valid(subpath) ? "true" : "false"'

stage_nix_expr normalise_success 'lib.boolToString (builtins.tryEval (lib.path.subpath.normalise subpath)).success'

stage_check valid == normalise_success

