{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  ounit,
  seq,
}:

let
  version_sha =
    if lib.versionAtLeast ocaml.version "4.08" then
      {
        version = "1.11.0";
        sha256 = "sha256-AfwkR4DA9r5yrnlrH7dQ82feGGJP110H7nl4LtbfjU8=";
      }
    else
      {
        version = "1.9.0";
        sha256 = "1gas4ky49zgxph3870nffzkr6y41kkpqp4nj38pz1gh49zcf12aj";
      };
in

buildDunePackage rec {
  pname = "re";
  version = version_sha.version;

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/ocaml/ocaml-re/releases/download/${version}/re-${version}.tbz";
    sha256 = version_sha.sha256;
  };

  buildInputs = lib.optional doCheck ounit;
  propagatedBuildInputs = [ seq ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    homepage = "https://github.com/ocaml/ocaml-re";
    description = "Pure OCaml regular expressions, with support for Perl and POSIX-style strings";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
