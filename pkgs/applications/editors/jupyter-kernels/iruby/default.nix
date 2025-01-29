{
  lib,
  bundlerApp,
}:

# Jupyter console:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter-console.withSingleKernel iruby.definition'

# Jupyter notebook:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter.override { definitions.iruby = iruby.definition; }'

let
  self = bundlerApp {
    pname = "iruby";
    gemdir = ./.;
    exes = [ "iruby" ];

    passthru = {
      definition = {
        displayName = "IRuby";
        argv = [
          "${self}/bin/iruby"
          "kernel"
          "{connection_file}"
        ];
        language = "ruby";
        logo32 = null;
        logo64 = null;
      };
    };

    meta = {
      description = "Ruby kernel for Jupyter";
      homepage = "https://github.com/SciRuby/iruby";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        costrouc
        thomasjm
      ];
      platforms = lib.platforms.unix;
    };
  };

in

self
