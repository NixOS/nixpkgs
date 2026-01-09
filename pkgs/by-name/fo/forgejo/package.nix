import ./generic.nix {
  version = "13.0.4";
  hash = "sha256-AZQ4ppJES4CsvlkzBX82KfEp3PlFa2Ypd1KmTj/SXJk=";
  npmDepsHash = "sha256-v+vl0fxcnqH8Jp4BILDYe5ioFQTQkB2XnFVEtkgadPc=";
  vendorHash = "sha256-tq/72teHKowp6jwOKIJxS0OkcFI7UV19uTAv/OB/rm8";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
