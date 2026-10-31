{
  amule,
  ...
}@args:

amule.override (
  {
    monolithic = false;
    apiServer = true;
    mainProgram = "amuleapi";
  }
  // removeAttrs args [ "amule" ]
)
