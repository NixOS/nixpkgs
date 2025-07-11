{ name, file }:
{
  config,
  pkgs,
  lib,
  options,
  utils,
  ...
}@args:

with (import ./mk-exporter.nix config.networking.nftables.enable lib pkgs);

{
  options.services.prometheus.exporters = mkDownstreamOptions name (import file args);
  config = mkDownstreamConfig name (import file args) config.services.prometheus.exporters.${name};
}
