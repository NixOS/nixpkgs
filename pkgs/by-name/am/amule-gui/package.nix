{
  amule,
  ...
}@args:

amule.override (
  {
    monolithic = false;
    client = true;
    mainProgram = "amulegui";
  }
  // removeAttrs args [ "amule" ]
)
