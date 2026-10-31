{
  ollama,
  ...
}@args:

ollama.override (
  {
    acceleration = "cuda";
  }
  // removeAttrs args [ "ollama" ]
)
