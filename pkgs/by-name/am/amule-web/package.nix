{
  amule,
  ...
}@args:

amule.override (
  {
    monolithic = false;
    httpServer = true;
    mainProgram = "amuleweb";
  }
  // removeAttrs args [ "amule" ]
)
