{
  stdenv,
  unixtools,
  procps-ng,
  withSystemd ? null,
}:

let
  linuxProcps =
    if withSystemd != null then procps-ng.override { inherit withSystemd; } else procps-ng;
in
# some platforms refer back to this from unixtools, so this is needed to
# break the cycle
if stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isCygwin then
  linuxProcps
else
  unixtools.procps
