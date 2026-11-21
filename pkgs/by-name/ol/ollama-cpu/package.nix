{
  ollama,
  ...
}@args:

ollama.override (
  {
    acceleration = false;
  }
  // removeAttrs args [ "ollama" ]
)
