{
  hostPkgs,
  rootPaths,
}:

let
  regInfo = hostPkgs.closureInfo { inherit rootPaths; };
in
{
  inherit regInfo;
  regInfoPath = "/nix/.ro-store/${baseNameOf regInfo}/registration";
}
