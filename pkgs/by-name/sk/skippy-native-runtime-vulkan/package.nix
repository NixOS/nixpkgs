{ skippy-native-runtime }:

# nixpkgs-update: no auto update
skippy-native-runtime.override { vulkanSupport = true; }
