src = [
  'nixos-option.cc',
  'libnix-copy-paste.cc',
]

cc = meson.get_compiler('cpp')

executable('nixos-option', src,
           dependencies : [
             nix_main_dep,
             nix_store_dep,
             nix_expr_dep,
             nix_cmd_dep,
             nix_flake_dep,
             boost_dep,
             nlohmann_json_dep,
             threads_dep
           ],
           install: true,
           cpp_args: ['-std=c++2a', '--include', 'nix/config.h'])
