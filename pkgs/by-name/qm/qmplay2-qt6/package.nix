{
  qmplay2,
  ...
}@args:

qmplay2.override (
  {
    qtVersion = "6";
  }
  // removeAttrs args [ "qmplay2" ]
)
