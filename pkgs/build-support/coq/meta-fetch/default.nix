{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
}@args:

let
  lib = import ../extra-lib.nix {
    inherit (args) lib;
  };

  inherit (lib)
    attrNames
    fakeSha256
    filter
    findFirst
    head
    isAttrs
    isPath
    isString
    last
    length
    optionalAttrs
    pathExists
    pred
    sort
    switch
    switch-if
    versionOlder
    versions
    ;

  inherit (lib.strings) match split;

  default-fetcher =
    {
      domain ? "github.com",
      owner ? "",
      repo,
      rev,
      name ? "source",
      sha256 ? null,
      artifact ? null,
      ...
    }@args:
    let
      kind =
        switch-if
          [
            {
              cond = artifact != null;
              out = {
                ext = "tbz";
                fmt = "tbz";
                fetchfun = fetchurl;
              };
            }
            {
              cond = args ? sha256;
              out = {
                ext = "zip";
                fmt = "zip";
                fetchfun = fetchzip;
              };
            }
          ]
          {
            ext = "tar.gz";
            fmt = "tarball";
            fetchfun = builtins.fetchTarball;
          };
    in
    with kind;
    let
      pr = match "^#(.*)$" rev;
      url = switch-if [
        {
          cond = pr == null && (match "^github.*" domain) != null && artifact != null;
          out = "https://github.com/${owner}/${repo}/releases/download/${rev}/${artifact}";
        }
        {
          cond = pr == null && (match "^github.*" domain) != null;
          out = "https://${domain}/${owner}/${repo}/archive/${rev}.${ext}";
        }
        {
          cond = pr != null && (match "^github.*" domain) != null;
          out = "https://api.${domain}/repos/${owner}/${repo}/${fmt}/pull/${head pr}/head";
        }
        {
          cond = pr == null && (match "^gitlab.*" domain) != null;
          out = "https://${domain}/${owner}/${repo}/-/archive/${rev}/${repo}-${rev}.${ext}";
        }
        {
          cond = (match "(www.)?mpi-sws.org" domain) != null;
          out = "https://www.mpi-sws.org/~${owner}/${repo}/download/${repo}-${rev}.${ext}";
        }
      ] (throw "meta-fetch: no fetcher found for domain ${domain} on ${rev}");
      fetch = x: fetchfun (if args ? sha256 then (x // { inherit sha256; }) else x);
    in
    fetch { inherit url; };
in
{
  fetcher ? default-fetcher,
  location,
  release ? { },
  releaseRev ? (v: v),
  releaseArtifact ? (v: null),
}:
let
  isVersion = x: isString x && match "^/.*" x == null && release ? ${x};
  shortVersion =
    x:
    if (isString x && match "^/.*" x == null) then
      findFirst (v: versions.majorMinor v == x) null (sort (l: r: versionOlder r l) (attrNames release))
    else
      null;
  isShortVersion = x: shortVersion x != null;
  isPathString = x: isString x && match "^/.*" x != null && pathExists x;
in
arg:
switch arg [
  {
    case = isNull;
    out = {
      version = "broken";
      src = "";
      broken = true;
    };
  }
  {
    case = isPathString;
    out = {
      version = "dev";
      src = arg;
    };
  }
  {
    case = pred.union isVersion isShortVersion;
    out =
      let
        v = if isVersion arg then arg else shortVersion arg;
        given-sha256 = release.${v}.sha256 or "";
        sha256 = if given-sha256 == "" then fakeSha256 else given-sha256;
        rv = release.${v} // {
          inherit sha256;
        };
      in
      {
        version = rv.version or v;
        src =
          rv.src or (fetcher (
            location
            // {
              rev = releaseRev v;
              artifact = releaseArtifact v;
            }
            // rv
          ));
      };
  }
  {
    case = isString;
    out =
      let
        splitted = filter isString (split ":" arg);
        rev = last splitted;
        has-owner = length splitted > 1;
        version = "dev";
      in
      {
        inherit version;
        src = fetcher (
          location // { inherit rev; } // (optionalAttrs has-owner { owner = head splitted; })
        );
      };
  }
  {
    case = isAttrs;
    out = {
      version = arg.version or "dev";
      src = (arg.fetcher or fetcher) (location // (arg.location or { }));
    };
  }
  {
    case = isPath;
    out = {
      version = "dev";
      src = builtins.path {
        path = arg;
        name = location.name or "source";
      };
    };
  }
] (throw "not a valid source description")
