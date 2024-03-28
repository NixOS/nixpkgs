# jupyter {#sec-jupyter}

Jupyter has different frontends that can be configured: jupyter-console and
jupyter-notebook. The approach is the same:
1. create a folder that contains all the jupyter kernels
2. wrap the executables

```nix
let
  definitions = {
      python = jupyterLib.mkKernelFromPythonEnv (python3.withPackages(ps: [
      ps.numpy ]);
      haskell = jupyterLib.mkKernelFromHaskellEnv (pkgs.haskellPackages.ghcWithPackages(hs: [ hs.aeson
      ]);
      # ... and all other kernels you are interested in
  };
  myKernels = jupyter-kernel.create {
    inherit definitions;
  };
in
  # pseudocode, real code in next sections
  jupyter frontend wrapped with JUPYTER_PATH=myKernels
```


## How to run jupyter-console with arbitrary kernels ? {#sec-jupyter-console}

```nix
myJupyterConsole = jupyter-console.mkConsole {
  inherit definitions;
}
```
