# Aggregation registry for modular services, keyed by
# `<pkg>.<service>.<environment>`.
#
# Each service instance (matching `passthru.services.<name>`) gets an entry per
# supported environment. Today only the `system` (NixOS system) environment is
# provided; a future `user` environment sits alongside it.
#
# Every modular service is enumerated here - including those with no
# environment-specific configuration - so the directory advertises which
# services are supported on the NixOS system environment.
{
  system = {
    ghostunnel.default = import ./ghostunnel/default/system.nix;
    snid.default = import ./snid/default/system.nix;
    ktls-utils.default = import ./ktls-utils/default/system.nix;
    autopush-rs = {
      autoconnect = import ./autopush-rs/autoconnect/system.nix;
      autoendpoint = import ./autopush-rs/autoendpoint/system.nix;
    };
    php.default = import ./php/default/system.nix;
    holo-daemon.default = import ./holo-daemon/default/system.nix;
    python-http-server.default = import ./python-http-server/default/system.nix;
  };
}
