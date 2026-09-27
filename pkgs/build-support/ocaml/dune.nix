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

      # OCaml libraries, and the dependencies they propagate, are only needed
      # to build other packages. Unless the package chooses its outputs or
      # installs itself, install them into "dev", so that they stay out of the
      # runtime closure of "out". Man pages and documentation go to "man" and
      # "doc".
      splitOutputs = !(args ? outputs || args ? installPhase);
    in

    if args ? minimalOCamlVersion && lib.versionOlder ocaml.version args.minimalOCamlVersion then
      throw "${pname}-${version} is not available for OCaml ${ocaml.version}"
    else
      {
        name = "ocaml${ocaml.version}-${pname}-${finalAttrs.version}";

        strictDeps = true;

        outputs =
          args.outputs or (
            [ "out" ]
            ++ lib.optionals splitOutputs [
              "dev"
              "man"
              "doc"
            ]
          );

        # The findlib setup hook always points OCAMLFIND_DESTDIR at $out.
        postHook = ''
          export OCAMLFIND_DESTDIR="''${!outputDev}/lib/ocaml/${ocaml.version}/site-lib/"
        ''
        + args.postHook or "";

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
            dune install --prefix $out --libdir $OCAMLFIND_DESTDIR ${lib.concatStringsSep " " dunePackages} \
             ${lib.optionalString (lib.versionAtLeast Dune.version "2.9") ''
               --docdir "''${!outputDoc}/share/doc" --mandir "''${!outputMan}/share/man" --etcdir "$out/etc" \
             ''} ${lib.optionalString (lib.versionAtLeast Dune.version "3.0") ''
               --bindir "''${!outputBin}/bin" --datadir "$out/share"
             ''}
            # Not every package installs something into each output.
            for output in $(getAllOutputNames); do
              mkdir -p "''${!output}"
            done
            runHook postInstall
          '';

        checkPhase =
          args.checkPhase or ''
            runHook preCheck
            dune runtest -p ${lib.concatStringsSep "," dunePackages} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
            runHook postCheck
          '';

        meta =
          (args.meta or { })
          // {
            platforms = args.meta.platforms or ocaml.meta.platforms;
          }
          # meta is often copied from another package, which may have other outputs.
          // lib.optionalAttrs (args.meta or { } ? outputsToInstall) {
            outputsToInstall = lib.intersectLists finalAttrs.outputs args.meta.outputsToInstall;
          };
      }
      // lib.optionalAttrs splitOutputs {
        # Dune packages that ship a configure script don't expect autoconf flags.
        setOutputFlags = args.setOutputFlags or false;
      };
}
