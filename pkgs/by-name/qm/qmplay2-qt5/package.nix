{
  qmplay2,
  ...
}@args:

qmplay2.override (
  {
    qtVersion = "5";
  }
  // removeAttrs args [ "qmplay2" ]
)
