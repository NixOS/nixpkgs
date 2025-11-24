{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  topkg,
  ocamlbuild,
  cmdliner,
  odoc,
  b0,
}:

{
  pname,
  version,
  nativeBuildInputs ? [ ],
  buildInputs ? [ ],
  ...
}@args:

lib.throwIf (args ? minimalOCamlVersion && lib.versionOlder ocaml.version args.minimalOCamlVersion)
  "${pname}-${version} is not available for OCaml ${ocaml.version}"

  stdenv.mkDerivation
  (
    {

      dontAddStaticConfigureFlags = true;
      configurePlatforms = [ ];
      strictDeps = true;
      inherit (topkg) buildPhase installPhase;

    }
    // (removeAttrs args [ "minimalOCamlVersion" ])
    // {

      name = "ocaml${ocaml.version}-${pname}-${version}";

      nativeBuildInputs = [
        ocaml
        findlib
        ocamlbuild
        topkg
      ]
      ++ nativeBuildInputs;
      buildInputs = [ topkg ] ++ buildInputs;

      meta = (args.meta or { }) // {
        platforms = args.meta.platforms or ocaml.meta.platforms;
      };

    }
  )
