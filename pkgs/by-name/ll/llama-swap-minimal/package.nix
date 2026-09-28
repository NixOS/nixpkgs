{ llama-swap }:

# if more "-minimal" options are added
# you may need to update main llama-swap's passthru.tests.nixos
llama-swap.override {
  withUI = false;
}
