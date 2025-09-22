{
  lib,
  fetchFromGitHub,
  python3,
  bcc,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sockdump";
  version = "0-unstable-2023-12-11";

  src = fetchFromGitHub {
    owner = "mechpen";
    repo = "sockdump";
    rev = "d40ec77e960d021861220bc14a273c5dcad13160";
    hash = "sha256-FLK1rgWvIoFGv/6+DtDhZGeOZrn7V1jYNS3S8qwL/dc=";
  };

  propagatedBuildInputs = [ bcc ];

  format = "other"; # none

  installPhase = "install -D sockdump.py $out/bin/sockdump";

  meta = src.meta // {
    description = "Dump unix domain socket traffic with bpf";
    mainProgram = "sockdump";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [
      picnoir
    ];
  };
}
