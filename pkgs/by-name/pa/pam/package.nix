{
  stdenv,
  linux-pam,
  freebsd,
  openpam,
}:

if stdenv.hostPlatform.isLinux then
  linux-pam
else if stdenv.hostPlatform.isFreeBSD then
  freebsd.libpam
else
  openpam
