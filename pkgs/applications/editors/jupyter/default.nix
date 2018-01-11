{ python3
, jupyterKernels
, kernelDefinitions ? jupyterKernels.defaultKernelDefinition
}:

let

  jupyterPath = (jupyterKernels.create  { kernelDefinitions =  kernelDefinitions; });

in

with python3.pkgs; toPythonModule (
  notebook.overrideAttrs(oldAttrs: {
    makeWrapperArgs = ["--set JUPYTER_PATH ${jupyterPath}"];
  })
)
