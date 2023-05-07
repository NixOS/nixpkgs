{ makeSetupHook, unzip }:
makeSetupHook
{
  name = "unpackVsixHook";
  deps = [ unzip ];
} ./unpack-vsix-hook.sh
