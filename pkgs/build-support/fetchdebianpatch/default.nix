{ lib, fetchpatch }:

lib.makeOverridable (
  { pname, version, debianRevision ? null, name, hash, area ? "main" }:
  let versionString =
    if debianRevision == null then version else "${version}-${debianRevision}";
  in fetchpatch {
    url =
      "https://sources.debian.org/data/${area}/${builtins.substring 0 1 pname}/"
      + "${pname}/${versionString}/debian/patches/${name}.patch";
    inherit hash;
  }
)
