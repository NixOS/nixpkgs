# Per-URL hash verification for every source fetched by
# `pkgs.linuxPackages.nvidiaPackages.*`.
#
# This is the Nix side of ./verify.sh; run that script rather than this file
# directly.  The result is a flat attribute set mapping
# "<path>-<system>-u<index>" to a fixed-output derivation that downloads
# exactly one URL of that source and checks it against the hash declared in
# nixpkgs.
#
# Nothing here knows about the NVIDIA namespace, about its component names or
# about concrete URLs.  The namespace is walked recursively: plain attribute
# sets are descended into (so a driver version exposed as a scope is found just
# like any other set) and every derivation whose `.src` is a fixed-output
# derivation carrying `urls`/`url` becomes one test per URL.  A derivation also
# contributes the entries of its `passthru`, one level deep, which is how the
# extra packages are exposed today; when they move into a scope instead, the
# plain attribute set recursion picks them up.
#
# The derivations are salted with `pkgs.testers.invalidateFetcherByDrvHash`,
# so each one has a unique store path that cannot be satisfied by an already
# populated store or binary cache: an actual download always happens on the
# first run.  This catches the case this file exists for, a hash that is only
# wrong for one of the URLs a source lists (GitHub vs. NVIDIA), which a normal
# build of the combined derivation would never notice because it stops at the
# first URL that works.
#
# Platform specific sources (the binary driver and fabricmanager archives) are
# read from a nixpkgs evaluation for each supported platform, so the 64-bit,
# 32-bit and aarch64 hashes are all covered.  Because the archives themselves
# are platform independent, each URL is downloaded by the host's own source
# derivation, with only the URL and the hash of that platform transplanted
# onto it.  That way a foreign platform is verified without a builder for it.
#
# Components that resolve to the same download (aliases such as `stable` and
# `production`, the `dc` alias, a driver's bundled `lib32`) each get their own
# check but share one derivation, so nothing is downloaded twice.
#
# Arguments (all optional):
#   pkgs     nixpkgs instance used to build the checks.  Defaults to this
#            repository with `allowUnfree` and `nvidia.acceptLicense` enabled,
#            which the unfree NVIDIA sources require.
#   systems  Linux platforms to read platform specific sources from, as a list
#            or a comma-separated string.  Platforms a driver does not support
#            are ignored.  Defaults to x86_64-linux, i686-linux and
#            aarch64-linux.
#   path     comma-separated substrings a component's path must contain, e.g.
#            "production" or "passthru.open"; empty means everything.
#   prefetch when true, every check asks for a bogus hash instead of the
#            declared one, so realising it always fails and reports the hash the
#            URL actually yields.  Used by ./verify.sh --prefetch to obtain new
#            hashes; the URLs still come from nixpkgs.
{
  pkgs ? import ../../.. {
    config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
  },
  systems ? null,
  path ? "",
  prefetch ? false,
}:

let
  inherit (pkgs) lib;

  defaultSystems = [
    "x86_64-linux"
    "i686-linux"
    "aarch64-linux"
  ];

  resolvedSystems =
    if systems == null || systems == "" then
      defaultSystems
    else if lib.isString systems then
      lib.splitString "," systems
    else
      systems;

  repo = ../../..;
  config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };

  hostSystem = pkgs.stdenv.hostPlatform.system;

  namespaceFor =
    system:
    (if system == hostSystem then pkgs else import repo { inherit system config; })
    .linuxPackages.nvidiaPackages;

  hostNamespace = namespaceFor hostSystem;

  # A component whose `.src` is a fixed-output derivation with URLs.  Anything
  # else (`mod.src` is a store path, disabled components are `{ }`, a driver's
  # `lib32` output, version strings) is skipped.
  isSource =
    drv:
    drv ? src
    && (
      let
        s = drv.src;
      in
      lib.isDerivation s && (s ? urls || s ? url)
    );

  urlsOf = src: lib.unique (if src ? urls && src.urls != [ ] then src.urls else [ src.url ]);

  # Attribute names must not contain ".", "/" or ":", which nix-instantiate
  # would read as an attribute path and silently skip.
  pathString = parts: lib.concatStringsSep "-" parts;

  normalizeSelector = selector: builtins.replaceStrings [ "." "/" ] [ "-" "-" ] selector;

  # A derivation is only touched for a platform it claims to support; foreign
  # (and unsupported) derivations may not even evaluate.  Without a
  # `meta.platforms` it is checked on the host only.
  available =
    system: drv:
    if drv ? meta && drv.meta ? platforms then
      lib.meta.availableOn { inherit system; } drv
    else
      system == hostSystem;

  # Recursively walk the namespace.  Plain attribute sets are descended into,
  # so a driver version exposed as a scope is discovered like any other set; a
  # derivation contributes itself and, when it is not already inside a
  # `passthru`, its `passthru` (where the extra packages live today).  The
  # `passthru` descent is deliberately one level deep, so a passthru entry that
  # is itself a package does not contribute its own passthru again.  Subtrees
  # that cannot be evaluated for `system` - unsupported platform branches, a
  # driver's bundled 32-bit libs - are dropped with `tryEval`.
  sourcesIn =
    system: namespace:
    let
      walk =
        inPassthru: path: value:
        let
          step = builtins.tryEval (
            if lib.isFunction value then
              [ ]
            else if lib.isDerivation value then
              lib.optionals (available system value) (
                [
                  {
                    inherit path;
                    drv = value;
                  }
                ]
                ++ lib.optionals (!inPassthru && value ? passthru) (
                  walk true (path ++ [ "passthru" ]) value.passthru
                )
              )
            else if lib.isAttrs value then
              lib.concatMap (name: walk inPassthru (path ++ [ name ]) value.${name}) (builtins.attrNames value)
            else
              [ ]
          );
        in
        if step.success then step.value else [ ];
    in
    walk false [ ] namespace;

  recordOf =
    system: component:
    let
      src = component.drv.src;
    in
    lib.imap0 (index: url: {
      inherit (component) path;
      inherit system index url;
      inherit (src)
        hash
        outputHash
        outputHashAlgo
        outputHashMode
        ;
      source = src;
    }) (urlsOf src);

  records = lib.concatMap (
    system:
    lib.concatMap (
      component:
      let
        check = builtins.tryEval (isSource component.drv);
      in
      lib.optionals (check.success && check.value) (recordOf system component)
    ) (sourcesIn system (namespaceFor system))
  ) resolvedSystems;

  # Identity of the actual download.  Aliases (`stable` for `production`, `dc`
  # for `dc_580`, ...) and platform-independent sources shared by several
  # platforms have the same identity, so they resolve to one derivation and a
  # single download.
  fetchKey =
    r:
    "${r.url}\n${toString r.outputHash}\n${
      if r.outputHashAlgo == null then "" else r.outputHashAlgo
    }\n${toString r.outputHashMode}";

  # One check per (component, URL): the same component seen again under another
  # platform is dropped, but different components (including aliases) stay.
  pathKey = r: "${pathString r.path}\n${fetchKey r}";

  checks = lib.foldl' (
    acc: r: if lib.any (seen: pathKey seen == pathKey r) acc then acc else acc ++ [ r ]
  ) [ ] records;

  representative = r: lib.findFirst (x: fetchKey x == fetchKey r) r records;

  systemTag = system: lib.head (lib.splitString "-" system);

  pathMatches =
    p:
    path == ""
    || lib.any (selector: lib.hasInfix (normalizeSelector selector) p) (lib.splitString "," path);

  # The host-buildable source derivation for the same component, with the
  # requested platform's URL and hash transplanted onto it.  In prefetch mode
  # the hash is replaced by a bogus one so realising it reports the real hash.
  mkTest =
    record:
    let
      base = (lib.getAttrFromPath record.path hostNamespace).src;
      name = "nvidia-source-hash-${pathString record.path}-${systemTag record.system}-u${toString record.index}";
      hashAttrs = {
        inherit (record) outputHashMode;
      }
      // (
        if prefetch then
          {
            hash = lib.fakeHash;
            outputHash = lib.fakeHash;
            outputHashAlgo = null;
          }
        else
          {
            inherit (record)
              hash
              outputHash
              outputHashAlgo
              ;
          }
      );
    in
    pkgs.testers.invalidateFetcherByDrvHash (
      args:
      base.overrideAttrs (
        _:
        {
          inherit (args) name;
          urls = [ record.url ];
        }
        // hashAttrs
      )
    ) { inherit name; };
in
lib.listToAttrs (
  map (
    r:
    lib.nameValuePair "${pathString r.path}-${systemTag r.system}-u${toString r.index}" (
      mkTest (representative r)
    )
  ) (lib.filter (r: pathMatches (pathString r.path)) checks)
)
