{ llama-cpp }:

# nixpkgs-update: no auto update
llama-cpp.override { rocmSupport = true; }
