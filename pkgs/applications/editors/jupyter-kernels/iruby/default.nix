{ lib
, bundlerApp
}:

<<<<<<< HEAD
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
      homepage    = "https://github.com/SciRuby/iruby";
      license     = lib.licenses.mit;
      maintainers = with lib.maintainers; [ costrouc thomasjm ];
      platforms   = lib.platforms.unix;
    };
  };

in

self
=======
bundlerApp {
  pname = "iruby";
  gemdir = ./.;
  exes = [ "iruby" ];

  meta = with lib; {
    description = "Ruby kernel for Jupyter";
    homepage    = "https://github.com/SciRuby/iruby";
    license     = licenses.mit;
    maintainers = [ maintainers.costrouc ];
    platforms   = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
