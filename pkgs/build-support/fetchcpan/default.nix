# `fetchCpan` function for fetching Perl distributions from CPAN.
{
  lib,
  fetchurl,
}:

lib.makeOverridable (
  {
    pname,
    version,
    author, # CPAN author ID, uppercase, e.g. "HAARG"
    hash ? "",
    sha256 ? "",
    extension ? "tar.gz",
    tarballVersion ? version, # override when tarball uses a different version string, e.g. "v${version}"
    ...
  }@attrs:
  let
    url = "mirror://cpan/authors/id/${builtins.substring 0 1 author}/${builtins.substring 0 2 author}/${author}/${pname}-${tarballVersion}.${extension}";
    meta = {
      identifiers.purlParts = {
        type = "cpan";
        # https://github.com/package-url/purl-spec/blob/master/PURL-TYPES.rst
        spec = "${author}/${pname}@${version}";
      };
    };
  in
  fetchurl (
    (removeAttrs attrs [
      "author"
      "extension"
      "tarballVersion"
    ])
    // {
      inherit
        url
        sha256
        hash
        meta
        ;
    }
  )
)
