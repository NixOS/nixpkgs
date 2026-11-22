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
        # to build other packages. Unless the package chooses its outputs,
        # those are installed into "dev", rather than "out", to minimize the
        # "out" runtime closure. Man pages and documentation go to "man" and
        # "doc".
        outputs =
          args.outputs or [
            "out"
            "dev"
            "man"
            "doc"
          ];

        # The findlib setup hook always points OCAMLFIND_DESTDIR at $out, so
        # override it after all setup hooks have run.
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

        # With several outputs, multiple-outputs.sh passes autoconf-style
        # --bindir/--libdir/--mandir/... flags to ./configure. The configure
        # scripts shipped by dune packages are hand-written and reject them.
        setOutputFlags = args.setOutputFlags or false;

        meta =
          let
            meta = args.meta or { };
            # meta is often copied from another package, which may have other
            # outputs. Keep the default if none of them are left.
            outputsToInstall = lib.intersectLists finalAttrs.outputs (meta.outputsToInstall or [ ]);
          in
          removeAttrs meta [ "outputsToInstall" ]
          // {
            platforms = meta.platforms or ocaml.meta.platforms;
          }
          // lib.optionalAttrs (outputsToInstall != [ ]) { inherit outputsToInstall; };
      };
}
