{

  # creates definitions that can be passed on to jupyter-kernel.create like this:
  # jupyter-kernel.create { definitions = { python3 = jupyterLib.mkKernelDefinition { ... } } }
  mkKernelDefinition = {
      # interpreter and its arguments
      argv ? [],
      displayName ? language,
      # e.g. "python"
      language,
      interruptMode ? null,
      metadata ? "",
      logo32 ? null,
      logo64 ? null,
      extraPaths ? {},
      ...
    }@unfilteredKernel:
      unfilteredKernel;
}
