{
  lib,
  nix-update,
}:

{
  attrPath ? null,
  extraArgs ? [ ],
}:

[ "${nix-update.exe}" ] ++ extraArgs ++ lib.optionals (attrPath != null) [ attrPath ]
