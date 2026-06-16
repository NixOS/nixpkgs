{
  bambootracker,
  ...
}@args:

bambootracker.override (
  {
    withQt6 = true;
  }
  // removeAttrs args [ "bambootracker" ]
)
