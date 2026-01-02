{
  lib,
  nix-update,
}:

{
  attrPath ? null,
  extraArgs ? [ ],
}:

[ "${lib.getExe nix-update}" ] ++ extraArgs ++ lib.optionals (attrPath != null) [ attrPath ]
