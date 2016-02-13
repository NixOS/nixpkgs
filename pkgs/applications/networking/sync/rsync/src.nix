{ version, fetchurl }:

fetchurl {
  # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
  url = "mirror://samba/rsync/src/rsync-${version}.tar.gz";
  sha256 = "1hm1q04hz15509f0p9bflw4d6jzfvpm1d36dxjwihk1wzakn5ypc";
}