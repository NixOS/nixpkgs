/**
  Renders documentation for modular services.
  For inclusion into documentation.nixos.extraModules.

  Rather than listing modular services by hand, this module walks `pkgs`
  and discovers any package that exposes a `services` attrset of modules
  (via `passthru.services`). Each discovered service is rendered as a
  synthetic NixOS option whose name is the angle-bracketed `imports = [...]`
  snippet a user would write to import it.

  Packages that re-export the same underlying service module (for example,
  `pkgs.php`, `pkgs.php82`, ..., `pkgs.php85`, which all point at the same
  `pkgs/development/interpreters/php/service.nix`) are deduplicated by
  fingerprinting each module via the `_file` metadata that
  `lib.modules.importApply` attaches to its result; the entry with the
  alphabetically-shortest package name wins.
*/
{ lib, pkgs, ... }:
let
  inherit (builtins) tryEval;
  inherit (lib) isAttrs isDerivation isList;

  /**
    Causes a modular service's docs to be rendered.
    This is an intermediate solution until we have "native" service docs in some nicer form.
  */
  fakeSubmodule =
    module:
    lib.mkOption {
      type = lib.types.submoduleWith {
        modules = [ module ];
      };
      description = "This is a [modular service](https://nixos.org/manual/nixos/unstable/#modular-services), which can be imported into a NixOS configuration using the [`system.services`](https://search.nixos.org/options?channel=unstable&show=system.services&query=modular+service) option.";
    };

  # Force `x`; return `null` on evaluation failure.
  tryOrNull =
    x:
    let
      r = tryEval x;
    in
    if r.success then r.value else null;

  # Fingerprint a service module so packages that re-export the same
  # underlying module can be deduplicated. We use the set of `_file`
  # attributes attached by `lib.modules.importApply` to each entry of the
  # module's `imports` list. Returns `null` if no stable fingerprint is
  # available; such entries are kept as-is (keyed by package name).
  fingerprint =
    module:
    let
      imports = tryOrNull (module.imports or [ ]);
      files =
        if isList imports then
          lib.sort (a: b: toString a < toString b) (
            lib.filter (p: p != null) (map (i: tryOrNull (i._file or null)) imports)
          )
        else
          [ ];
    in
    if files == [ ] then null else toString files;

  # Walk `pkgs` once and collect every `pkgs.<pkgName>.services.<moduleName>`
  # modular service. Access is guarded with `tryEval` because many packages
  # throw on instantiation (platform mismatches, aliases, etc.).
  discoveredServices =
    let
      candidates = lib.filter (n: !(lib.hasPrefix "_" n)) (builtins.attrNames pkgs);
      entriesFor =
        pkgName:
        let
          pkg = tryOrNull pkgs.${pkgName};
          # Packages expose modular services via `passthru.services`, which
          # surfaces as `pkg.services` on the derivation itself — so derivations
          # are valid candidates here, we just need the `services` attribute
          # to be present.
          hasServices = pkg != null && isAttrs pkg && pkg ? services;
          services = if hasServices then tryOrNull pkg.services else null;
          isUsable = services != null && isAttrs services && !(isDerivation services);
        in
        if isUsable then
          lib.mapAttrsToList (moduleName: module: {
            inherit pkgName moduleName module;
          }) (lib.filterAttrs (_: v: v != null && isAttrs v && !(isDerivation v)) services)
        else
          [ ];
    in
    lib.concatMap entriesFor candidates;

  # Deduplicate discovered entries that share the same fingerprint, keeping
  # the entry with the alphabetically-shortest `pkgName`. Entries without a
  # fingerprint are kept as distinct items.
  dedupedServices =
    let
      keyOf =
        entry:
        let
          fp = fingerprint entry.module;
        in
        if fp == null then
          # Unique key per entry so unfingerprintable modules aren't merged.
          "unique:${entry.pkgName}.${entry.moduleName}"
        else
          "fp:${entry.moduleName}:${fp}";
      better =
        a: b:
        let
          la = lib.stringLength a.pkgName;
          lb = lib.stringLength b.pkgName;
        in
        if la != lb then la < lb else a.pkgName < b.pkgName;
      step =
        acc: entry:
        let
          key = keyOf entry;
          existing = acc.${key} or null;
        in
        if existing == null || better entry existing then acc // { ${key} = entry; } else acc;
    in
    lib.attrValues (lib.foldl' step { } discoveredServices);

  modularServicesModule = {
    options = lib.listToAttrs (
      map (
        { pkgName, moduleName, module }:
        {
          name = "<imports = [ pkgs.${pkgName}.services.${moduleName} ]>";
          value = fakeSubmodule module;
        }
      ) dedupedServices
    );
  };
in
{
  documentation.nixos.extraModules = [
    modularServicesModule
  ];
}
