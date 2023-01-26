stage_setup 1000
stage_awk_expr subpath 'gen_valid_subpath()'
stage_nix_expr appended '/. + ("/" + subpath)'
stage_nix_expr normalised_appended '/. + ("/" + lib.path.subpath.normalise subpath)'
stage_check appended == normalised_appended
