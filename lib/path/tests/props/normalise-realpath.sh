stage_setup 300
stage_awk_expr subpath 'gen_valid_subpath()'
stage_nix_expr subpath_normalised 'lib.path.subpath.normalise subpath'
stage_bash_expr subpath_realpath 'realpath -m --relative-to=$PWD -- "$subpath"'
stage_bash_expr subpath_normalised_realpath 'realpath -m --relative-to=$PWD -- "${subpath_normalised}"'

stage_check subpath_realpath == subpath_normalised_realpath
