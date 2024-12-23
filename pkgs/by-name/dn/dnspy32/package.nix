{
  stdenv,
  pkgsCross,
  dnspy,
}:
if (stdenv.hostPlatform.isWindows) then
  pkgsCross.mingw32.dnspy
else
  dnspy.override { is32Bit = true; }
