{ lib, stdenv, coqPackages, coq, fetchzip }@args:
let lib = import ./extra-lib.nix {inherit (args) lib;}; in
with builtins; with lib;
let
  isGitHubDomain = d: match "^github.*" d != null;
  isGitLabDomain = d: match "^gitlab.*" d != null;
  mk =
  { pname,
    version ? null,
    origin ? null,
    fetcher ? null,
    owner ? "coq-community",
    domain ? "github.com",
    repo ? pname,
    defaultVersion ? null,
    releaseRev ? (v: v),
    displayVersion ? {},
    release ? {},
    extraBuildInputs ? [],
    namePrefix ? [],
    enableParallelBuilding ? true,
    extraInstallFlags ? [],
    setCOQBIN ? true,
    mlPlugin ? false,
    useMelquiondRemake ? null,
    dropAttrs ? [],
    keepAttrs ? [],
    dropDerivationAttrs ? [],
    useDune2ifVersion ? (x: false),
    useDune2 ? false,
    ...
  }@args:
  let
    args-to-remove = foldl (flip remove) ([
      "version" "origin" "fetcher" "repo" "owner" "domain" "releaseRev"
      "displayVersion" "defaultVersion" "useMelquiondRemake"
      "release" "extraBuildInputs" "extraPropagatedBuildInputs" "namePrefix"
      "meta" "useDune2ifVersion" "useDune2"
      "extraInstallFlags" "setCOQBIN" "mlPlugin"
      "dropAttrs" "dropDerivationAttrs" "keepAttrs" ] ++ dropAttrs) keepAttrs;
    fetched = import ../coq/meta-fetch/default.nix
      { inherit lib stdenv fetchzip; }
      ({ inherit release releaseRev; combined = true;
         location = { inherit domain owner repo; };
      } // optionalAttrs (args?fetcher) {inherit fetcher;})
      { inherit pname origin version defaultVersion; };
    namePrefix = args.namePrefix or [ "coq" ];
    display-pkg = n: sep: v:
      let d = displayVersion.${n} or (if sep == "" then ".." else true); in
      n + optionalString (v != "" && v != null) (switch d [
        { case = true;       out = sep + v; }
        { case = ".";        out = sep + versions.major v; }
        { case = "..";       out = sep + versions.majorMinor v; }
        { case = "...";      out = sep + versions.majorMinorPatch v; }
        { case = isFunction; out = optionalString (d v != "") (sep + d v); }
        { case = isString;   out = optionalString (d != "") (sep + d); }
      ] "") + optionalString (v == null) "-broken";
    append-version = p: n: p + display-pkg n "" coqPackages.${n}.version + "-";
    prefix-name = foldl append-version "" namePrefix;
    var-coqlib-install = (optionalString (versions.isGe "8.7" coq.coq-version) "COQMF_") + "COQLIB";
    useDune2 = args.useDune2 or useDune2ifVersion fetched.version;
  in

  flip removeAttrs dropDerivationAttrs ({

    name = prefix-name + (display-pkg pname "-" fetched.version);

    inherit (fetched) version src;

    buildInputs = [ coq ]
      ++ optionals mlPlugin coq.ocamlBuildInputs
      ++ optionals useDune2 [coq.ocaml coq.ocamlPackages.dune_2]
      ++ extraBuildInputs;
    inherit enableParallelBuilding;

    meta = ({ platforms = coq.meta.platforms; } //
      (switch domain [{
          case = pred.union isGitHubDomain isGitLabDomain;
          out = { homepage = "https://${domain}/${owner}/${repo}"; };
        }] {}) //
      optionalAttrs (fetched.broken or false) { coqFilter = true; broken = true; }) //
      (args.meta or {}) ;

  }
  // (optionalAttrs setCOQBIN { COQBIN = "${coq}/bin/"; })
  // (optionalAttrs (!args?installPhase && !args?useMelquiondRemake) {
    installFlags =
      [ "${var-coqlib-install}=$(out)/lib/coq/${coq.coq-version}/" ] ++
      optional (match ".*doc$" (args.installTargets or "") != null)
        "DOCDIR=$(out)/share/coq/${coq.coq-version}/" ++
      extraInstallFlags;
  })
  // (optionalAttrs useDune2 {
    installPhase = ''
      runHook preInstall
      dune install --prefix=$out
      mv $out/lib/coq $out/lib/TEMPORARY
      mkdir $out/lib/coq/
      mv $out/lib/TEMPORARY $out/lib/coq/${coq.coq-version}
      runHook postInstall
    '';
  })
  // (optionalAttrs (args?useMelquiondRemake) rec {
    COQUSERCONTRIB = "$out/lib/coq/${coq.coq-version}/user-contrib";
    preConfigurePhases = "autoconf";
    configureFlags = [ "--libdir=${COQUSERCONTRIB}/${useMelquiondRemake.logpath or ""}" ];
    buildPhase = "./remake -j$NIX_BUILD_CORES";
    installPhase = "./remake install";
  })
  // (removeAttrs args args-to-remove));
in
args: stdenv.mkDerivation (switch args [
  { case = isFunction; out = fix (x: mk (args x)); }
  { case = isAttrs;    out = mk args; }
] (throw "mkCoqDerivation: unsupported argments (must be set or set -> set)"))
