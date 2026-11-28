# Per-URL hash verification for every source fetched by
# `pkgs.linuxPackages.nvidiaPackages.*`.
#
# This is the Nix side of ./verify.sh; run that script rather than this file
# directly. The result maps "<path>-<system>-u<index>" to a fixed-output
# derivation that downloads one URL of a source and checks it against the hash
# nixpkgs declares.
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
# Each derivation is salted with `pkgs.testers.invalidateFetcherByDrvHash`, so no
# cache or substituter can satisfy it. A previous run of this script on the same
# machine can, so run it after each change rather than twice. That catches a
# hash that is wrong for one of a source's URLs (GitHub vs. NVIDIA), which a
# build of the combined derivation misses because it stops at the first working
# URL.
#
# Platform specific sources (the binary driver and fabricmanager archives) are
# read from a nixpkgs evaluation per platform, covering the 64-bit, 32-bit and
# aarch64 hashes. The archives are platform independent, so each URL is
# downloaded by the host's own source derivation with that platform's URL and
# hash transplanted onto it, which needs no builder for the foreign platform. A
# source the host itself does not have is skipped.
#
# Components that resolve to the same download (aliases such as `stable` and
# `production`, the `dc` alias, a driver's bundled `lib32`) each get their own
# check but share one derivation, so nothing is downloaded twice.
#
# Arguments (all optional):
#   pkgs     nixpkgs instance used to build the checks. Defaults to this
#            repository with `allowUnfree` and `nvidia.acceptLicense` enabled,
#            which the unfree NVIDIA sources require.
#   systems  Linux platforms to read platform specific sources from, as a list
#            or a comma-separated string. Platforms a driver does not support
#            are ignored. Defaults to x86_64-linux, i686-linux and
#            aarch64-linux.
#   path     comma-separated substrings a component's path must contain, e.g.
#            "production" or "passthru.open"; empty means everything.
#   prefetch when true, every check asks for a bogus hash instead of the
#            declared one, so realising it always fails and reports the hash the
#            URL actually yields. Used by ./verify.sh --prefetch to obtain new
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
      map lib.trim (builtins.filter (s: s != "") (lib.splitString "," systems))
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

  # A source the host itself cannot build, either because the branch has no
  # archive for its platform or because the derivation refuses that platform,
  # has no source derivation to transplant a foreign URL onto. It is skipped.
  # `getAttrFromPath` aborts on a missing path and `tryEval` cannot catch
  # aborts, so the presence of the path is checked first.
  hostBuildable =
    r:
    let
      probe = builtins.tryEval (
        lib.hasAttrByPath r.path hostNamespace
        && builtins.seq (lib.getAttrFromPath r.path hostNamespace).src true
      );
    in
    probe.success && probe.value;

  # A component whose `.src` is a fixed-output derivation with URLs. Anything
  # else, such as `mod.src` (a store path) or a disabled component, is skipped.
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

  # A derivation is only touched for a platform it claims to support, since a
  # foreign one may not evaluate. Without `meta.platforms`, the host decides.
  available =
    system: drv:
    if drv ? meta && drv.meta ? platforms then
      lib.meta.availableOn { inherit system; } drv
    else
      system == hostSystem;

  # What one member of the namespace contributes: the sources found below it,
  # and the paths below it that failed to evaluate.
  empty = {
    sources = [ ];
    failures = [ ];
  };

  merge = a: b: {
    sources = a.sources ++ b.sources;
    failures = a.failures ++ b.failures;
  };

  ofSources = sources: {
    inherit sources;
    failures = [ ];
  };

  ofFailure = path: {
    sources = [ ];
    failures = [ path ];
  };

  # Recursively walk the namespace: attribute sets descend, a derivation also
  # contributes its `passthru` one level deep. A member that fails to evaluate
  # keeps its path, so it does not drop out of the verification. Everything the
  # walk reads of a member is decided while the pair for it is built, so the
  # handler covers the member and its children alike.
  sourcesIn =
    system: namespace:
    let
      walk =
        inPassthru: path: value:
        let
          result =
            if lib.isFunction value then
              empty
            else if lib.isDerivation value then
              if !(available system value) then
                empty
              else
                merge
                  (ofSources [
                    {
                      inherit path;
                      drv = value;
                    }
                  ])
                  (
                    if !inPassthru && value ? passthru then walk true (path ++ [ "passthru" ]) value.passthru else empty
                  )
            else if lib.isAttrs value then
              lib.foldl' merge empty (lib.mapAttrsToList (name: walk inPassthru (path ++ [ name ])) value)
            else
              empty;
          step = builtins.tryEval result;
        in
        if step.success then step.value else ofFailure path;
    in
    walk false [ ] namespace;

  recordOf =
    system: component:
    let
      inherit (component.drv) src;
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

  # The walk of every platform, kept once so the sources and the failures found
  # below come from a single evaluation.
  walked = lib.map (system: {
    inherit system;
    walked = sourcesIn system (namespaceFor system);
  }) resolvedSystems;

  components = lib.concatMap (
    w:
    lib.map (component: {
      inherit (w) system;
      inherit component;
    }) w.walked.sources
  ) walked;

  # Reading a component's record reads its source, so a component whose source
  # cannot be read is reported rather than skipped silently. A component this
  # host cannot build is skipped knowingly instead, the same way the checks cut
  # it for want of a source to transplant a URL onto, which is what
  # `hostBuildable` decides without reading the record. The fields the checks
  # read are forced inside the handler because the records are built lazily.
  readOne =
    { system, component }:
    let
      usable = hostBuildable {
        inherit (component) path;
      };
      records = lib.optionals (usable && isSource component.drv) (recordOf system component);
      forced = builtins.deepSeq (map (r: [
        r.path
        r.system
        r.index
        r.url
        r.hash
        r.outputHash
        r.outputHashAlgo
        r.outputHashMode
      ]) records) records;
      step = builtins.tryEval forced;
    in
    if !usable then
      empty
    else if step.success then
      ofSources step.value
    else
      ofFailure component.path;

  read = lib.foldl' merge empty (lib.map readOne components);

  records = read.sources;

  # A path this host does not have belongs to the platform passes, so it is not
  # a failure here. Everything else that failed to evaluate is reported.
  failures = lib.unique (
    lib.filter (path: lib.hasAttrByPath path hostNamespace) (
      lib.concatMap (w: w.walked.failures) walked ++ read.failures
    )
  );

  # Identity of the actual download. Aliases and sources shared by several
  # platforms have the same identity, so they resolve to one derivation.
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

  # The host-buildable component that carries the same download, or null when
  # the host has none.
  representative = r: lib.findFirst (x: fetchKey x == fetchKey r && hostBuildable x) null records;

  systemTag = system: lib.head (lib.splitString "-" system);

  pathMatches =
    p:
    path == ""
    || lib.any (selector: lib.hasInfix (normalizeSelector selector) p) (lib.splitString "," path);

  # The host-buildable source derivation of a component that carries this
  # download, with this record's URL and hash transplanted on. Prefetch swaps in
  # a bogus hash.
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
  selected = lib.filter (r: pathMatches (pathString r.path)) checks;

  # A check is only useful when some component carrying the same download can
  # be built on this host; the rest have nothing to transplant a URL onto.
  withHostBase = builtins.concatMap (
    r:
    let
      rep = representative r;
    in
    lib.optional (rep != null) {
      inherit r rep;
    }
  ) selected;
in
if failures == [ ] then
  lib.listToAttrs (
    map (
      p:
      lib.nameValuePair "${pathString p.r.path}-${systemTag p.r.system}-u${toString p.r.index}" (
        mkTest p.rep
      )
    ) withHostBase
  )
else
  throw ''
    ${toString (lib.length failures)} namespace entries stayed unverified because they could not be evaluated:
    ${lib.concatMapStrings (failure: "  ${pathString failure}\n") failures}
  ''
