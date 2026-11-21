{
  ollama,
  ...
}@args:

ollama.override (
  {
    acceleration = "rocm";
  }
  // removeAttrs args [ "ollama" ]
)
