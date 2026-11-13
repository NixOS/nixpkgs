{
  adwaita-qt,
  ...
}@args:

adwaita-qt.override (
  {
    useQt6 = true;
  }
  // removeAttrs args [ "adwaita-qt" ]
)
