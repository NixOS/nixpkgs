{ python3
, jupyter-kernel
, jupyterLib
, lib
}:
{
  # Build a console derivation with an arbitrary set of definitions, and an optional kernel to use.
  # If the kernel argument is not supplied, Jupyter console will pick a kernel to run from the ones
  # available on the system.
  inherit (jupyterLib) mkConsole;

  # An ergonomic way to start a console with a single kernel.
  withSingleKernel = definition: jupyterLib.mkConsole {
    definitions = lib.listToAttrs [(lib.nameValuePair definition.language definition)];
    kernel = definition.language;
  };
}
