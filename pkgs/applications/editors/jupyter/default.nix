# Jupyter notebook with the given kernel definitions

{
  python3,
  jupyter-kernel,
  definitions ? jupyter-kernel.default,
}:

let
  jupyterPath = (jupyter-kernel.create { inherit definitions; });
  jupyter-notebook =
    (python3.buildEnv.override {
      extraLibs = [ python3.pkgs.notebook ];
      makeWrapperArgs = [ "--prefix JUPYTER_PATH : ${jupyterPath}" ];
    }).overrideAttrs
      (oldAttrs: {
        meta = oldAttrs.meta // {
          mainProgram = "jupyter-notebook";
        };
      });
in

jupyter-notebook
