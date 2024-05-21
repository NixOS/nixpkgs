{lib, ...}:
{ options = {
    key = lib.mkOption {
      type        = lib.types.str;
      example     = "/etc/ssl/keys/mykeyfile.key";
      default     = "/etc/ssl/keys/server.key";
      description = ''
        Path to the TLS key file.
      '';
    };

    crt = lib.mkOption {
      type        = lib.types.str;
      example     = "/etc/ssl/certs/mycert.crt";
      default     = "/etc/ssl/certs/server.crt";
      description = ''
        Path to the TLS certificate file.
      '';
    };
  };
}
