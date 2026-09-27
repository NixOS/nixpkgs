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
      dunePackages ? [ pname ],
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
        name = "ocaml${ocaml.version}-${pname}-${finalAttrs.version}";

        strictDeps = true;

        # OCaml libraries, and the dependencies they propagate, are only needed
        # to build other packages. Install them into "dev", so that they stay
        # out of the runtime closure of "out". Packages with a custom
        # installPhase have to opt in by setting outputs themselves.
        outputs =
          args.outputs or (
            if args ? installPhase then
              [ "out" ]
            else
              [
                "out"
                "dev"
              ]
          );
        # Dune packages that ship a configure script don't expect autoconf flags.
        setOutputFlags = args.setOutputFlags or false;

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
            dune build -p ${lib.concatStringsSep "," dunePackages} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
            runHook postBuild
          '';

        installPhase =
          args.installPhase or ''
            runHook preInstall
            export OCAMLFIND_DESTDIR="''${!outputDev}/lib/ocaml/${ocaml.version}/site-lib/"
            dune install --prefix $out --libdir $OCAMLFIND_DESTDIR ${lib.concatStringsSep " " dunePackages} \
             ${lib.optionalString (lib.versionAtLeast Dune.version "2.9") ''
               --docdir "''${!outputDoc}/share/doc" --mandir "''${!outputMan}/share/man" \
             ''} ${lib.optionalString (lib.versionAtLeast Dune.version "3.0") ''
               --bindir "''${!outputBin}/bin"
             ''}
            # Libraries without executables or docs don't install anything into $out.
            mkdir -p "$out"
            runHook postInstall
          '';

        checkPhase =
          args.checkPhase or ''
            runHook preCheck
            dune runtest -p ${lib.concatStringsSep "," dunePackages} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
            runHook postCheck
          '';

        meta = (args.meta or { }) // {
          platforms = args.meta.platforms or ocaml.meta.platforms;
        };
      };
}
