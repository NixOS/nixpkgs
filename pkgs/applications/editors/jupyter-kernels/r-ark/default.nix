{ ark }:

# Jupyter notebook:
# nix shell --impure --expr 'with import ./. {}; [ (jupyter.override { definitions.r = r-ark-kernel.definition; }) ]' -c jupyter-notebook

{
  definition = {
    displayName = "Ark R Kernel";
    argv = [
      "${ark}/bin/ark"
      "--connection_file"
      "{connection_file}"
      "--session-mode"
      "notebook"
    ];
    language = "R";
    # Ark logs at INFO to stderr by default, which includes Jupyter messages.
    # The notebook forwards this to the cell output, so quiet it to warnings.
    #
    # The `ark::console::console_comm=error` directive additionally silences a
    # per-cell "UI comm is absent during dispatch" warning: after every execute,
    # ark unconditionally tries to push an environment-pane update over the
    # Positron-only `positron.ui` comm, which a plain Jupyter frontend never
    # opens.
    env = {
      RUST_LOG = "ark=warn,ark::console::console_comm=error";
    };
    logo32 = null;
    logo64 = null;
  };
}
