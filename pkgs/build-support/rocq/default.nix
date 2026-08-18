{
  lib,
  stdenv,
  rocqPackages,
  rocq-core,
  coq,
  which,
  fetchzip,
  fetchurl,
  dune,
}@args0:

let
  lib = import ./extra-lib.nix {
    inherit (args0) lib;
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
  owner ? "rocq-community",
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
  namePrefix ? null,
  enableParallelBuilding ? true,
  extraInstallFlags ? [ ],
  setROCQBIN ? true,
  mlPlugin ? false,
  useMelquiondRemake ? null,
  dropAttrs ? [ ],
  keepAttrs ? [ ],
  dropDerivationAttrs ? [ ],
  useDuneifVersion ? (x: false),
  useDune ? false,
  opam-name ? null,
  useCoq ? false,
  useCoqifVersion ? (x: false),
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
      "setROCQBIN"
      "mlPlugin"
      "dropAttrs"
      "dropDerivationAttrs"
      "keepAttrs"
      "env"
      "useCoq"
      "useCoqifVersion"
    ]
    ++ dropAttrs
  ) keepAttrs;
  fetch =
    import ../rocq/meta-fetch/default.nix
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
  useDune = args.useDune or (useDuneifVersion fetched.version);
  useCoq = args.useCoq or (useCoqifVersion fetched.version);
  namePrefix = args.namePrefix or [ (if useCoq then "coq" else "rocq") ];
  append-version =
    p: n:
    let
      version = if n == "rocq" then rocqPackages.rocq-core.version else rocqPackages.${n}.version;
    in
    p + display-pkg n "" version + "-";
  prefix-name = foldl append-version "" namePrefix;
  opam-name = args.opam-name or (concatStringsSep "-" (namePrefix ++ [ pname ]));
  rocq-core = if useCoq then coq // { rocq-version = coq.coq-version; } else args0.rocq-core;
  rocqlib-flags = [
    "COQLIBINSTALL=$(out)/lib/coq/${rocq-core.rocq-version}/user-contrib"
    "COQPLUGININSTALL=$(OCAMLFIND_DESTDIR)"
  ];
  docdir-flags = [ "COQDOCINSTALL=$(out)/share/coq/${rocq-core.rocq-version}/user-contrib" ];
  COQUSERCONTRIB = "$out/lib/coq/${rocq-core.rocq-version}/user-contrib";
in

stdenv.mkDerivation (
  removeAttrs (
    {

      name = prefix-name + (display-pkg pname "-" fetched.version);

      inherit (fetched) version src;

      nativeBuildInputs =
        args.overrideNativeBuildInputs or (
          [ which ]
          ++ optional useDune dune
          ++ optionals (useDune || mlPlugin) [
            rocq-core.ocamlPackages.ocaml
            rocq-core.ocamlPackages.findlib
          ]
          ++ (args.nativeBuildInputs or [ ])
          ++ extraNativeBuildInputs
        );
      buildInputs =
        args.overrideBuildInputs or ([ rocq-core ] ++ (args.buildInputs or [ ]) ++ extraBuildInputs);
      inherit enableParallelBuilding;

      env =
        optionalAttrs (setROCQBIN && !useCoq) {
          ROCQBIN = "${rocq-core}/bin/";
        }
        // optionalAttrs (setROCQBIN && useCoq) { COQBIN = "${rocq-core}/bin/"; }
        // optionalAttrs (args ? useMelquiondRemake) {
          inherit COQUSERCONTRIB;
        }
        // (args.env or { });

      preBuild =
        optionalString (useCoq && useDune && lib.versionAtLeast rocq-core.rocq-version "9.0") ''
          export COQPATH="$ROCQPATH"
        ''
        + (args.preBuild or "");

      meta =
        (
          {
            platforms = rocq-core.meta.platforms;
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
            rocqFilter = true;
            broken = true;
          }
        )
        // (args.meta or { });

    }
    // (optionalAttrs (!args ? installPhase && !args ? useMelquiondRemake) {
      installFlags = rocqlib-flags ++ docdir-flags ++ extraInstallFlags;
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
        mv $OCAMLFIND_DESTDIR/coq $out/lib/coq/${rocq-core.rocq-version}
        runHook postInstall
      '';
    })
    // (optionalAttrs (args ? useMelquiondRemake) {
      preConfigurePhases = [ "autoconf" ];
      configureFlags = [ "--libdir=${COQUSERCONTRIB}/${useMelquiondRemake.logpath or ""}" ];
      buildPhase = "./remake -j$NIX_BUILD_CORES";
      installPhase = "./remake install";
    })
    // (removeAttrs args args-to-remove)
  ) dropDerivationAttrs
)
