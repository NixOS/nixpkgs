{
  replaceVarsWith,
  perl,
  dbPath ? "/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite",
}:
replaceVarsWith {
  name = "command-not-found";
  dir = "bin";

  src = ./command-not-found.pl;
  isExecutable = true;

  replacements = {
    inherit dbPath;
    perl = perl.withPackages (p: [
      p.DBDSQLite
      p.StringShellQuote
    ]);
  };

  passthru = {
    inherit dbPath;
  };

  meta = {
    description = "Provides package suggestions when a command is not found";
    mainProgram = "command-not-found";
  };
}
