{ fetchurl }:

{ project, major, minor, patchlevel ? null, extension ? "bz2", sha256 }:

let
  baseVersion = "${major}.${minor}";
  version = baseVersion + (if patchlevel != null then ".${patchlevel}" else "");
  name = "${project}-${version}";
in

(fetchurl {
  url = "mirror://gnome/sources/${project}/${baseVersion}/${name}.tar.${extension}";
  inherit sha256;
}) // {
  inherit major minor patchlevel baseVersion version;
  pkgname = name;
}
