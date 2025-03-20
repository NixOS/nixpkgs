{
  lib,
  stdenv,
  coqPackages,
  coq,
  which,
  fetchzip,
  fetchurl,
}@args:

let
  lib = import ./extra-lib.nix {
    inherit (args) lib;
  };

  inherit (lib)
    concatStringsSep
    flip
    foldl
    isFunction
    isString
    optional
    optionalAttrs
    optionals
    optionalString
    pred
    remove
    switch
    versions
    ;

  inherit (lib.attrsets) removeAttrs;
  inherit (lib.strings) match;

  isGitHubDomain = d: match "^github.*" d != null;
  isGitLabDomain = d: match "^gitlab.*" d != null;
in

{
  pname,
  version ? null,
  fetcher ? null,
  owner ? "coq-community",
  domain ? "github.com",
  repo ? pname,
  defaultVersion ? null,
  releaseRev ? (v: v),
  displayVersion ? { },
  release ? { },
  buildInputs ? [ ],
  nativeBuildInputs ? [ ],
  extraBuildInputs ? [ ],
  extraNativeBuildInputs ? [ ],
  overrideBuildInputs ? [ ],
  overrideNativeBuildInputs ? [ ],
  namePrefix ? [ "coq" ],
  enableParallelBuilding ? true,
  extraInstallFlags ? [ ],
  setCOQBIN ? true,
  mlPlugin ? false,
  useMelquiondRemake ? null,
  dropAttrs ? [ ],
  keepAttrs ? [ ],
  dropDerivationAttrs ? [ ],
  useDuneifVersion ? (x: false),
  useDune ? false,
  opam-name ? (concatStringsSep "-" (namePrefix ++ [ pname ])),
  ...
}@args:
let
  args-to-remove = foldl (flip remove) (
    [
      "version"
      "fetcher"
      "repo"
      "owner"
      "domain"
      "releaseRev"
      "displayVersion"
      "defaultVersion"
      "useMelquiondRemake"
      "release"
      "buildInputs"
      "nativeBuildInputs"
      "extraBuildInputs"
      "extraNativeBuildInputs"
      "overrideBuildInputs"
      "overrideNativeBuildInputs"
      "namePrefix"
      "meta"
      "useDuneifVersion"
      "useDune"
      "opam-name"
      "extraInstallFlags"
      "setCOQBIN"
      "mlPlugin"
      "dropAttrs"
      "dropDerivationAttrs"
      "keepAttrs"
    ]
    ++ dropAttrs
  ) keepAttrs;
  fetch =
    import ../coq/meta-fetch/default.nix
      {
        inherit
          lib
          stdenv
          fetchzip
          fetchurl
          ;
      }
      (
        {
          inherit release releaseRev;
          location = { inherit domain owner repo; };
        }
        // optionalAttrs (args ? fetcher) { inherit fetcher; }
      );
  fetched = fetch (if version != null then version else defaultVersion);
  display-pkg =
    n: sep: v:
    let
      d = displayVersion.${n} or (if sep == "" then ".." else true);
    in
    n
    + optionalString (v != "" && v != null) (
      switch d [
        {
          case = true;
          out = sep + v;
        }
        {
          case = ".";
          out = sep + versions.major v;
        }
        {
          case = "..";
          out = sep + versions.majorMinor v;
        }
        {
          case = "...";
          out = sep + versions.majorMinorPatch v;
        }
        {
          case = isFunction;
          out = optionalString (d v != "") (sep + d v);
        }
        {
          case = isString;
          out = optionalString (d != "") (sep + d);
        }
      ] ""
    )
    + optionalString (v == null) "-broken";
  append-version = p: n: p + display-pkg n "" coqPackages.${n}.version + "-";
  prefix-name = foldl append-version "" namePrefix;
  useDune = args.useDune or (useDuneifVersion fetched.version);
  coqlib-flags =
    switch coq.coq-version
      [
        {
          case = v: versions.isLe "8.6" v && v != "dev";
          out = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];
        }
      ]
      [
        "COQLIBINSTALL=$(out)/lib/coq/${coq.coq-version}/user-contrib"
        "COQPLUGININSTALL=$(OCAMLFIND_DESTDIR)"
      ];
  docdir-flags =
    switch coq.coq-version
      [
        {
          case = v: versions.isLe "8.6" v && v != "dev";
          out = [ "DOCDIR=$(out)/share/coq/${coq.coq-version}/" ];
        }
      ]
      [ "COQDOCINSTALL=$(out)/share/coq/${coq.coq-version}/user-contrib" ];
in

stdenv.mkDerivation (
  removeAttrs (
    {

      name = prefix-name + (display-pkg pname "-" fetched.version);

      inherit (fetched) version src;

      nativeBuildInputs =
        args.overrideNativeBuildInputs or (
          [ which ]
          ++ optional useDune coq.ocamlPackages.dune_3
          ++ optionals (useDune || mlPlugin) [
            coq.ocamlPackages.ocaml
            coq.ocamlPackages.findlib
          ]
          ++ (args.nativeBuildInputs or [ ])
          ++ extraNativeBuildInputs
        );
      buildInputs =
        args.overrideBuildInputs or ([ coq ] ++ (args.buildInputs or [ ]) ++ extraBuildInputs);
      inherit enableParallelBuilding;

      meta =
        (
          {
            platforms = coq.meta.platforms;
          }
          // (switch domain [
            {
              case = pred.union isGitHubDomain isGitLabDomain;
              out = {
                homepage = "https://${domain}/${owner}/${repo}";
              };
            }
          ] { })
          // optionalAttrs (fetched.broken or false) {
            coqFilter = true;
            broken = true;
          }
        )
        // (args.meta or { });

    }
    // (optionalAttrs setCOQBIN { COQBIN = "${coq}/bin/"; })
    // (optionalAttrs (!args ? installPhase && !args ? useMelquiondRemake) {
      installFlags = coqlib-flags ++ docdir-flags ++ extraInstallFlags;
    })
    // (optionalAttrs useDune {
      buildPhase = ''
        runHook preBuild
        dune build -p ${opam-name} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
        runHook postBuild
      '';
      installPhase = ''
        runHook preInstall
        dune install --prefix=$out --libdir $OCAMLFIND_DESTDIR ${opam-name}
        mkdir $out/lib/coq/
        mv $OCAMLFIND_DESTDIR/coq $out/lib/coq/${coq.coq-version}
        runHook postInstall
      '';
    })
    // (optionalAttrs (args ? useMelquiondRemake) rec {
      COQUSERCONTRIB = "$out/lib/coq/${coq.coq-version}/user-contrib";
      preConfigurePhases = [ "autoconf" ];
      configureFlags = [ "--libdir=${COQUSERCONTRIB}/${useMelquiondRemake.logpath or ""}" ];
      buildPhase = "./remake -j$NIX_BUILD_CORES";
      installPhase = "./remake install";
    })
    // (removeAttrs args args-to-remove)
  ) dropDerivationAttrs
)
