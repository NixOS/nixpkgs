{ mesh-llm-native-runtime }:

# nixpkgs-update: no auto update
mesh-llm-native-runtime.override { vulkanSupport = true; }
