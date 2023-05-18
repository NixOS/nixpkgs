{ lib, ... }:
{ options = {
    server = lib.mkOption {
      type =
        lib.types.either
          (lib.types.submodule (import ./server-options.nix))
          (lib.types.path);
      example = {
        host = "127.0.0.1";
        port = 8888;
      };
      default = {
        host = "127.0.0.1";
        port = 80;
      };
      description = lib.mdDoc ''
        Frontend server interface binding specification as either a
        host:port pair or a unix domain docket.

        NB: a host of "*" listens on all interfaces and includes IPv6
        addresses.
      '';
    };

    params = lib.mkOption {
      type    = lib.types.nullOr (lib.types.submodule (import ./frontend-params-submodule.nix));
      example = {
        tls   = "tls";
      };
      default     = null;
      description = lib.mdDoc ''
        Parameters to configure a backend.
      '';
    };
  };
}
