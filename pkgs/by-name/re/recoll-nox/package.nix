{
  recoll,
  ...
}@args:

recoll.override (
  {
    withGui = false;
  }
  // removeAttrs args [ "recoll" ]
)
