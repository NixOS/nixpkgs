stage_setup 1000
stage_awk_expr subpath 'gen_valid_subpath()'
stage_nix_expr normalised 'lib.path.subpath.normalise subpath'
stage_nix_expr normalised_valid 'lib.boolToString (lib.path.subpath.isValid normalised)'
stage_constant normalised_valid_expected true
stage_check normalised_valid == normalised_valid_expected

stage_nix_expr normalised_twice 'lib.path.subpath.normalise normalised'
stage_check normalised == normalised_twice
