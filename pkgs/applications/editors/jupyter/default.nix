# Jupyter notebook with the given kernel definitions

{ python3
, jupyter-kernel
, definitions ? jupyter-kernel.default
}:

let

  jupyterPath = (jupyter-kernel.create { inherit definitions; });

in

with python3.pkgs; toPythonModule (
  notebook.overridePythonAttrs(oldAttrs: {
    makeWrapperArgs = ["--set JUPYTER_PATH ${jupyterPath}"];
  })
)
