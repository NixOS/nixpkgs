{
  steam,
  millennium,
  extraPkgs ? (_: [ ]),
  extraLibraries ? (_: [ ]),
  ...
}@args:
let
  millenniumLibraries = libPkgs: [
    millennium
    libPkgs.openssl
  ];
  upstreamArgs = removeAttrs args [
    "steam"
    "millennium"
  ];
in
steam.override (
  upstreamArgs
  // {
    extraPkgs = pkgs: extraPkgs pkgs;
    extraLibraries = pkgs: (millenniumLibraries pkgs) ++ (extraLibraries pkgs);
  }
)
