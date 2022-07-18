# Provide a /etc/passwd and /etc/group that contain root and nobody.
# Useful when packaging binaries that insist on using nss to look up
# username/groups (like nginx).
# /bin/sh is fine to not exist, and provided by another shim.
{ symlinkJoin, writeTextDir, runCommand }:
symlinkJoin {
  name = "fake-nss";
  paths = [
    (writeTextDir "etc/passwd" ''
      root:x:0:0:root user:/var/empty:/bin/sh
      nobody:x:65534:65534:nobody:/var/empty:/bin/sh
    '')
    (writeTextDir "etc/group" ''
      root:x:0:
      nobody:x:65534:
    '')
    (writeTextDir "etc/nsswitch.conf" ''
      hosts: files dns
    '')
    (runCommand "var-empty" { } ''
      mkdir -p $out/var/empty
    '')
  ];
}
