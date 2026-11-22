{
  amule,
  ...
}@args:

amule.override (
  {
    monolithic = false;
    textClient = true;
    mainProgram = "amulecmd";
  }
  // removeAttrs args [ "amule" ]
)
