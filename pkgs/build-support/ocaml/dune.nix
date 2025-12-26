{
  lib,
  stdenv,
  ocaml,
  findlib,
  dune_2,
  dune_3,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  excludeDrvArgNames = [
    "minimalOCamlVersion"
    "duneVersion"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      pname,
      version,
      nativeBuildInputs ? [ ],
      enableParallelBuilding ? true,
      ...
    }@args:

    let
      Dune =
        let
          dune-version = args.duneVersion or "3";
        in
        {
          "1" = throw "Support for dune version 1 has been removed";
          "2" = dune_2;
          "3" = dune_3;
        }
        ."${dune-version}";
    in

    if args ? minimalOCamlVersion && lib.versionOlder ocaml.version args.minimalOCamlVersion then
      throw "${pname}-${version} is not available for OCaml ${ocaml.version}"
    else
      {
        name = "ocaml${ocaml.version}-${pname}-${version}";

        strictDeps = true;

        inherit enableParallelBuilding;
        dontAddStaticConfigureFlags = true;
        configurePlatforms = [ ];

        nativeBuildInputs = [
          ocaml
          Dune
          findlib
        ]
        ++ nativeBuildInputs;

        buildPhase =
          args.buildPhase or ''
            runHook preBuild
            dune build -p ${pname} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
            runHook postBuild
          '';

        installPhase =
          args.installPhase or ''
            runHook preInstall
            dune install --prefix $out --libdir $OCAMLFIND_DESTDIR ${pname} \
             ${
               if lib.versionAtLeast Dune.version "2.9" then
                 "--docdir $out/share/doc --mandir $out/share/man"
               else
                 ""
             }
            runHook postInstall
          '';

        checkPhase =
          args.checkPhase or ''
            runHook preCheck
            dune runtest -p ${pname} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
            runHook postCheck
          '';

        meta = (args.meta or { }) // {
          platforms = args.meta.platforms or ocaml.meta.platforms;
        };
      };
}
