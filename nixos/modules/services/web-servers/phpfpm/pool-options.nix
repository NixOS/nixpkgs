{ lib }:

with lib; {

  options = {

    listen = mkOption {
      type = types.str;
      example = "/path/to/unix/socket";
      description = ''
        The address on which to accept FastCGI requests.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      example = ''
        user = nobody
        pm = dynamic
        pm.max_children = 75
        pm.start_servers = 10
        pm.min_spare_servers = 5
        pm.max_spare_servers = 20
        pm.max_requests = 500
      '';

      description = ''
        Extra lines that go into the pool configuration.
        See the documentation on <literal>php-fpm.conf</literal> for
        details on configuration directives.
      '';
    };
  };
}

