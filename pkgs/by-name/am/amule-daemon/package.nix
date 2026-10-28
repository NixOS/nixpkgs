{
  amule,
  ...
}@args:

amule.override (
  {
    monolithic = false;
    enableDaemon = true;
    mainProgram = "amuled";
  }
  // removeAttrs args [ "amule" ]
)
