{ lib, fetchpatch }:

lib.makeOverridable (
  { pname, version, debianRevision ? null, patch, hash,
    area ? "main", name ? "${patch}.patch" }:
  let versionString =
    if debianRevision == null then version else "${version}-${debianRevision}";
  in fetchpatch {
    inherit name hash;
    url =
      "https://sources.debian.org/data/${area}/${builtins.substring 0 1 pname}/"
      + "${pname}/${versionString}/debian/patches/${patch}.patch";
  }
)
