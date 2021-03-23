{ lib, stdenv, fetchzip }@args:
let lib' = lib; in
let lib = import ../extra-lib.nix {lib = lib';}; in
with builtins; with lib;
let
  default-fetcher = {domain ? "github.com", owner ? "", repo, rev, name ? "source", sha256 ? null, ...}@args:
    let ext = if args?sha256 then "zip" else "tar.gz";
        fmt = if args?sha256 then "zip" else "tarball";
        pr  = match "^#(.*)$" rev;
        url = switch-if [
          { cond = isNull pr && !isNull (match "^github.*" domain);
            out = "https://${domain}/${owner}/${repo}/archive/${rev}.${ext}"; }
          { cond = !isNull pr && !isNull (match "^github.*" domain);
            out = "https://api.${domain}/repos/${owner}/${repo}/${fmt}/pull/${head pr}/head"; }
          { cond = isNull pr && !isNull (match "^gitlab.*" domain);
            out = "https://${domain}/${owner}/${repo}/-/archive/${rev}/${repo}-${rev}.${ext}"; }
          { cond = !isNull (match "(www.)?mpi-sws.org" domain);
            out = "https://www.mpi-sws.org/~${owner}/${repo}/download/${repo}-${rev}.${ext}";}
        ] (throw "meta-fetch: no fetcher found for domain ${domain} on ${rev}");
        fetch = x: if args?sha256 then fetchzip (x // { inherit sha256; }) else fetchTarball x;
    in fetch { inherit url ; };
in
{
  fetcher ? default-fetcher,
  location,
  release ? {},
  releaseRev ? (v: v),
}:
let isVersion      = x: isString x && match "^/.*" x == null && release?${x};
    shortVersion   = x: if (isString x && match "^/.*" x == null)
      then findFirst (v: versions.majorMinor v == x) null
        (sort versionAtLeast (attrNames release))
      else null;
    isShortVersion = x: shortVersion x != null;
    isPathString   = x: isString x && match "^/.*" x != null && pathExists x; in
arg:
switch arg [
  { case = isNull;       out = { version = "broken"; src = ""; broken = true; }; }
  { case = isPathString; out = { version = "dev"; src = arg; }; }
  { case = pred.union isVersion isShortVersion;
    out = let v = if isVersion arg then arg else shortVersion arg; in
      let
        given-sha256 = release.${v}.sha256 or "";
        sha256 = if given-sha256 == "" then lib.fakeSha256 else given-sha256;
        rv = release.${v} // { inherit sha256; }; in
      {
        version = rv.version or v;
        src = rv.src or fetcher (location // { rev = releaseRev v; } // rv);
      };
    }
  { case = isString;
    out = let
        splitted  = filter isString (split ":" arg);
        rev       = last splitted;
        has-owner = length splitted > 1;
        version   = "dev"; in {
      inherit version;
      src = fetcher (location // { inherit rev; } //
        (optionalAttrs has-owner { owner = head splitted; }));
    }; }
  { case = isAttrs;
    out = let
    { version = arg.version or "dev";
      src = (arg.fetcher or fetcher) (location // (arg.location or {}));
    }; }
  { case = isPath;
    out = {
      version = "dev" ;
      src = builtins.path {path = arg; name = location.name or "source";}; }; }
] (throw "not a valid source description")
