{ lib, ... }:
{
  options = {
    proto = lib.mkOption {
      type = lib.types.enum [
        "h2"
        "http/1.1"
      ];
      default = "http/1.1";
      description = ''
        This option configures the protocol the backend server expects
        to use.

        Please see https://nghttp2.org/documentation/nghttpx.1.html#cmdoption-nghttpx-b
        for more detail.
      '';
    };

    tls = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        This option determines whether nghttpx will negotiate its
        connection with a backend server using TLS or not. The burden
        is on the backend server to provide the TLS certificate!

        Please see https://nghttp2.org/documentation/nghttpx.1.html#cmdoption-nghttpx-b
        for more detail.
      '';
    };

    sni = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Override the TLS SNI field value. This value (in nghttpx)
        defaults to the host value of the backend configuration.

        Please see https://nghttp2.org/documentation/nghttpx.1.html#cmdoption-nghttpx-b
        for more detail.
      '';
    };

    fall = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = ''
        If nghttpx cannot connect to the backend N times in a row, the
        backend is assumed to be offline and is excluded from load
        balancing. If N is 0 the backend is never excluded from load
        balancing.

        Please see https://nghttp2.org/documentation/nghttpx.1.html#cmdoption-nghttpx-b
        for more detail.
      '';
    };

    rise = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = ''
        If the backend is excluded from load balancing, nghttpx will
        periodically attempt to make a connection to the backend. If
        the connection is successful N times in a row the backend is
        re-included in load balancing. If N is 0 a backend is never
        reconsidered for load balancing once it falls.

        Please see https://nghttp2.org/documentation/nghttpx.1.html#cmdoption-nghttpx-b
        for more detail.
      '';
    };

    affinity = lib.mkOption {
      type = lib.types.enum [
        "ip"
        "none"
      ];
      default = "none";
      description = ''
        If "ip" is given, client IP based session affinity is
        enabled. If "none" is given, session affinity is disabled.

        Session affinity is enabled (by nghttpx) per-backend
        pattern. If at least one backend has a non-"none" affinity,
        then session affinity is enabled for all backend servers
        sharing the same pattern.

        It is advised to set affinity on all backends explicitly if
        session affinity is desired. The session affinity may break if
        one of the backend gets unreachable, or backend settings are
        reloaded or replaced by API.

        Please see https://nghttp2.org/documentation/nghttpx.1.html#cmdoption-nghttpx-b
        for more detail.
      '';
    };

    dns = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Name resolution of a backends host name is done at start up,
        or configuration reload. If "dns" is true, name resolution
        takes place dynamically.

        This is useful if a backends address changes frequently. If
        "dns" is true, name resolution of a backend's host name at
        start up, or configuration reload is skipped.

        Please see https://nghttp2.org/documentation/nghttpx.1.html#cmdoption-nghttpx-b
        for more detail.
      '';
    };

    redirect-if-not-tls = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If true, a backend match requires the frontend connection be
        TLS encrypted. If it is not, nghttpx responds to the request
        with a 308 status code and https URI the client should use
        instead in the Location header.

        The port number in the redirect URI is 443 by default and can
        be changed using 'services.nghttpx.redirect-https-port'
        option.

        If at least one backend has "redirect-if-not-tls" set to true,
        this feature is enabled for all backend servers with the same
        pattern. It is advised to set "redirect-if-no-tls" parameter
        to all backends explicitly if this feature is desired.

        Please see https://nghttp2.org/documentation/nghttpx.1.html#cmdoption-nghttpx-b
        for more detail.
      '';
    };
  };
}
