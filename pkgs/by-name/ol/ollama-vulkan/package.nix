{
  ollama,
  ...
}@args:

ollama.override (
  {
    acceleration = "vulkan";
  }
  // removeAttrs args [ "ollama" ]
)
