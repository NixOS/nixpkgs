{ llama-cpp, ... }@args:

llama-cpp.override ({ vulkanSupport = true; } // (removeAttrs args [ "llama-cpp" ]))
