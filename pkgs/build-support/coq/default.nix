{ lib, stdenv, coqPackages, coq, fetchzip }@args:
let lib = import ./extra-lib.nix {inherit (args) lib;}; in
with builtins; with lib;
let
  isGitHubDomain = d: match "^github.*" d != null;
  isGitLabDomain = d: match "^gitlab.*" d != null;
in
{ pname,
  version ? null,
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
  ...
}@args:
let
  args-to-remove = foldl (flip remove) ([
    "version" "fetcher" "repo" "owner" "domain" "releaseRev"
    "displayVersion" "defaultVersion" "useMelquiondRemake"
    "release" "extraBuildInputs" "extraPropagatedBuildInputs" "namePrefix" "meta"
    "extraInstallFlags" "setCOQBIN" "mlPlugin"
    "dropAttrs" "dropDerivationAttrs" "keepAttrs" ] ++ dropAttrs) keepAttrs;
  fetch = import ../coq/meta-fetch/default.nix
    { inherit lib stdenv fetchzip; } ({
      inherit release releaseRev;
      location = { inherit domain owner repo; };
    } // optionalAttrs (args?fetcher) {inherit fetcher;});
  fetched = fetch (if !isNull version then version else defaultVersion);
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
in

stdenv.mkDerivation (removeAttrs ({

  name = prefix-name + (display-pkg pname "-" fetched.version);

  inherit (fetched) version src;

  buildInputs = [ coq ] ++ optionals mlPlugin coq.ocamlBuildInputs ++ extraBuildInputs;
  inherit enableParallelBuilding;

  meta = ({ platforms = coq.meta.platforms; } //
    (switch domain [{
        case = pred.union isGitHubDomain isGitLabDomain;
        out = { homepage = "https://${domain}/${owner}/${repo}"; };
      }] {}) //
    optionalAttrs (fetched.broken or false) { coqFilter = true; broken = true; }) //
    (args.meta or {}) ;

} //
(optionalAttrs setCOQBIN { COQBIN = "${coq}/bin/"; }) //
(optionalAttrs (!args?installPhase && !args?useMelquiondRemake) {
  installFlags =
    [ "${var-coqlib-install}=$(out)/lib/coq/${coq.coq-version}/" ] ++
    optional (match ".*doc$" (args.installTargets or "") != null)
      "DOCDIR=$(out)/share/coq/${coq.coq-version}/" ++
    extraInstallFlags;
}) //
(optionalAttrs (args?useMelquiondRemake) rec {
  COQUSERCONTRIB = "$out/lib/coq/${coq.coq-version}/user-contrib";
  preConfigurePhases = "autoconf";
  configureFlags = [ "--libdir=${COQUSERCONTRIB}/${useMelquiondRemake.logpath or ""}" ];
  buildPhase = "./remake -j$NIX_BUILD_CORES";
  installPhase = "./remake install";
}) //
(removeAttrs args args-to-remove)) dropDerivationAttrs)
