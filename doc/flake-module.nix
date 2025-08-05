{
  lib,
  config,
  ...
}:
{
  outputs.htmlDocs.nixpkgsManual = lib.flip lib.mapAttrs config.perSystem.applied.jobs (
    _: jobSet: jobSet.manual
  );
}
