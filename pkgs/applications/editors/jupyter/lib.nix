{ jupyter-kernel, python3, lib, ...}:
{
  /* Generates a kernel definition from a haskell environment

      Example:
        let ghcEnv = pkgs.haskellPackages.ghcWithPackages (p: [ p.aeson ]);
        in mkKernelFromHaskellEnv ghcEnv;

      Type:
        mkKernelFromHaskellEnv :: Derivation -> AttrSet
  */
  mkKernelFromHaskellEnv = ghcEnv:
    let
      ghcEnv' = ghcEnv.withPackages (p: [ p.ihaskell ]);
    in

    {
      displayName = "Haskell";
      argv = [
        "${ghcEnv'}/bin/ihaskell"
        "-l"
        # the ihaskell flake does `-l $(${env}/bin/ghc --print-libdir`
        # we guess the path via hardcoded
        # we can't use name else we get the 'with-packages' suffix
        "${ghcEnv}/lib/ghc-${ghcEnv.version}"
        "kernel"
        "{connection_file}"
      ];
      language = "haskell";
      logo32 = null;
      logo64 = null;
    };


    /* Generates a kernel definition from a python environment
    Example:
      let pyEnv = pkgs.python3.withPackages (p: [ p.numpy ]);
      in mkKernelFromPythonEnv pyEnv;

    Type:
      mkKernelFromPythonEnv :: Derivation -> AttrSet
     */
    mkKernelFromPythonEnv = env: let
      env' = env.override(prev: {
        # fastai
        extraLibs = prev.extraLibs ++ [ env.python.pkgs.ipykernel ];
      });

    in
     {
      displayName = "Python 3";
      argv = [
        env'.interpreter
        "-m"
        "ipykernel_launcher"
        "-f"
        "{connection_file}"
      ];
      language = "python";
      logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
      logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
    };

  mkConsole = {
    definitions ? jupyter-kernel.default
    , kernel ? null
  }:
    (python3.buildEnv.override {
      extraLibs = [ python3.pkgs.jupyter-console ];
      makeWrapperArgs = [
        "--set JUPYTER_PATH ${jupyter-kernel.create { inherit definitions; }}"
      ] ++ lib.optionals (kernel != null) [
        "--add-flags --kernel"
        "--add-flags ${kernel}"
      ];
    }).overrideAttrs (oldAttrs: {
      # To facilitate running nix run .#jupyter-console
      meta = oldAttrs.meta // { mainProgram = "jupyter-console"; };
    });

}
