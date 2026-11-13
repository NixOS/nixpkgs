{
  zint-qt,
  ...
}@args:

zint-qt.override (
  {
    withGUI = false;
  }
  // removeAttrs args [ "zint-qt" ]
)
