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
    fakeHash
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
    warn
    warnIf
    ;

  inherit (lib.strings) match split;

  default-fetcher =
    {
      domain ? "github.com",
      owner ? "",
      repo,
      rev,
      name ? "source",
      hash ? null, # hash set to null to fetch arbitrary Rocq versions (only used downstreams)
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
              cond = hash != null;
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
            fetchfun = warn ''
              You are using `builtins.fetchTarball` as fetcher for ${owner}/${repo}, this is deprecated and will be removed in the 26.05 release. If you are a downstream user and what a similar solution, consider using `builtins.fetchTarball` in your own source tree and pass the fetched absolute path to Rocq meta-fetch helper.
            '' builtins.fetchTarball;
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
      # the sha256 here is only for builtins.fetchTarball backward compatibility
      fetch =
        x:
        fetchfun (
          if !(isNull hash) then
            (x // { inherit hash; })
          else if (isNull hash && args ? sha256) then
            (x // { inherit sha256; })
          else
            x
        );
    in
    fetch { inherit url; };
in
{
  fetcher ? default-fetcher,
  location, # contains name, owner, repo, domain, etc.
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
arg: # fetcher args
switch arg [
  {
    # if null, mark as broken
    case = isNull;
    out = {
      version = "broken";
      src = "";
      broken = true;
    };
  }
  {
    # use absolute path as source directly
    case = isPathString;
    out = {
      version = "dev";
      src = arg;
    };
  }
  {
    # (most common) use release info and pass to user defined fetcher or default fetcher
    case = pred.union isVersion isShortVersion;
    out =
      let
        v = if isVersion arg then arg else shortVersion arg;
        hash = switch-if [
          {
            cond = release.${v} ? hash && release.${v}.hash != "";
            out = release.${v}.hash;
          }
          {
            cond =
              warnIf (release.${v} ? sha256) ''
                When building ${location.owner}/${location.repo}, Rocq's default fetcher now uses `hash` instead of `sha256` (deprecated). Support for `sha256` will be removed in 26.05 release.
              '' release.${v}.sha256 != "";
            out = release.${v}.sha256;
          }
        ] fakeHash;
        rv = release.${v} // {
          inherit hash;
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
    # DEPRECATED (downstream only): use builtins.fetchTarball to fetch arbitrary Rocq versions
    case = isString;
    out =
      let
        splitted = filter isString (split ":" arg);
        rev = last splitted;
        hasOwner = length splitted > 1;
        version = "dev";
      in
      {
        inherit version;
        src = fetcher (location // { inherit rev; } // (optionalAttrs hasOwner { owner = head splitted; }));
      };
  }
  {
    # use user defined fetcher with given attrs
    case = isAttrs;
    out = {
      version = arg.version or "dev";
      src = (arg.fetcher or fetcher) (arg.location or { });
    };
  }
  {
    # make aribitrary path available as source
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
