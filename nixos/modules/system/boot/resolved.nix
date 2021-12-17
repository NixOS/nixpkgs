{ config, lib, ... }:

with lib;
let
  cfg = config.services.resolved;

  dnsmasqResolve = config.services.dnsmasq.enable &&
                   config.services.dnsmasq.resolveLocalQueries;

in
{

  options = {

    services.resolved.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable the systemd DNS resolver daemon.
      '';
    };

    services.resolved.fallbackDns = mkOption {
      default = [ ];
      example = [ "8.8.8.8" "2001:4860:4860::8844" ];
      type = types.listOf types.str;
      description = ''
        A list of IPv4 and IPv6 addresses to use as the fallback DNS servers.
        If this option is empty, a compiled-in list of DNS servers is used instead.
      '';
    };

    services.resolved.domains = mkOption {
      default = config.networking.search;
      defaultText = literalExpression "config.networking.search";
      example = [ "example.com" ];
      type = types.listOf types.str;
      description = ''
        A list of domains. These domains are used as search suffixes
        when resolving single-label host names (domain names which
        contain no dot), in order to qualify them into fully-qualified
        domain names (FQDNs).

        For compatibility reasons, if this setting is not specified,
        the search domains listed in
        <filename>/etc/resolv.conf</filename> are used instead, if
        that file exists and any domains are configured in it.
      '';
    };

    services.resolved.llmnr = mkOption {
      default = "true";
      example = "false";
      type = types.enum [ "true" "resolve" "false" ];
      description = ''
        Controls Link-Local Multicast Name Resolution support
        (RFC 4795) on the local host.

        If set to

        <variablelist>
        <varlistentry>
          <term><literal>"true"</literal></term>
          <listitem><para>
            Enables full LLMNR responder and resolver support.
          </para></listitem>
        </varlistentry>
        <varlistentry>
          <term><literal>"false"</literal></term>
          <listitem><para>
            Disables both.
          </para></listitem>
        </varlistentry>
        <varlistentry>
          <term><literal>"resolve"</literal></term>
          <listitem><para>
            Only resolution support is enabled, but responding is disabled.
          </para></listitem>
        </varlistentry>
        </variablelist>
      '';
    };

    services.resolved.dnssec = mkOption {
      default = "allow-downgrade";
      example = "true";
      type = types.enum [ "true" "allow-downgrade" "false" ];
      description = ''
        If set to
        <variablelist>
        <varlistentry>
          <term><literal>"true"</literal></term>
          <listitem><para>
            all DNS lookups are DNSSEC-validated locally (excluding
            LLMNR and Multicast DNS). Note that this mode requires a
            DNS server that supports DNSSEC. If the DNS server does
            not properly support DNSSEC all validations will fail.
          </para></listitem>
        </varlistentry>
        <varlistentry>
          <term><literal>"allow-downgrade"</literal></term>
          <listitem><para>
            DNSSEC validation is attempted, but if the server does not
            support DNSSEC properly, DNSSEC mode is automatically
            disabled. Note that this mode makes DNSSEC validation
            vulnerable to "downgrade" attacks, where an attacker might
            be able to trigger a downgrade to non-DNSSEC mode by
            synthesizing a DNS response that suggests DNSSEC was not
            supported.
          </para></listitem>
        </varlistentry>
        <varlistentry>
          <term><literal>"false"</literal></term>
          <listitem><para>
            DNS lookups are not DNSSEC validated.
          </para></listitem>
        </varlistentry>
        </variablelist>
      '';
    };

    services.resolved.dnsovertls = mkOption {
      default = "false";
      example = "true";
      type = types.enum [ "true" "opportunistic" "false" ];
      description = ''
        If set to
        <variablelist>
        <varlistentry>
          <term><literal>"true"</literal></term>
          <listitem><para>
            all connections to the server will be encrypted.
            Note that this mode requires a DNS server that supports
            DNS-over-TLS and has a valid certificate. If the hostname
            was specified using the format "address#server_name"
            it is used to validate its certificate and also to enable
            Server Name Indication (SNI) when opening a TLS connection.
            Otherwise the certificate is checked against the server's
            IP. If the DNS server does not support DNS-over-TLS all
            DNS requests will fail.
          </para></listitem>
        </varlistentry>
        <varlistentry>
          <term><literal>"opportunistic"</literal></term>
          <listitem><para>
            DNS request are attempted to send encrypted with DNS-over-TLS.
            If the DNS server does not support TLS, DNS-over-TLS is disabled.
            Note that this mode makes DNS-over-TLS vulnerable to "downgrade"
            attacks, where an attacker might be able to trigger a downgrade
            to non-encrypted mode by synthesizing a response that suggests
            DNS-over-TLS was not supported.
            </para></listitem>
        </varlistentry>
        <varlistentry>
          <term><literal>"false"</literal></term>
          <listitem><para>
            DNS lookups are send over UDP.
          </para></listitem>
        </varlistentry>
        </variablelist>
      '';
    };

    services.resolved.extraConfig = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Extra config to append to resolved.conf.
      '';
    };

  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = !config.networking.useHostResolvConf;
        message = "Using host resolv.conf is not supported with systemd-resolved";
      }
    ];

    users.users.systemd-resolve.group = "systemd-resolve";

    # add resolve to nss hosts database if enabled and nscd enabled
    # system.nssModules is configured in nixos/modules/system/boot/systemd.nix
    # added with order 501 to allow modules to go before with mkBefore
    system.nssDatabases.hosts = (mkOrder 501 ["resolve [!UNAVAIL=return]"]);

    systemd.additionalUpstreamSystemUnits = [
      "systemd-resolved.service"
    ];

    systemd.services.systemd-resolved = {
      wantedBy = [ "multi-user.target" ];
      aliases = [ "dbus-org.freedesktop.resolve1.service" ];
      restartTriggers = [ config.environment.etc."systemd/resolved.conf".source ];
    };

    environment.etc = {
      "systemd/resolved.conf".text = ''
        [Resolve]
        ${optionalString (config.networking.nameservers != [])
          "DNS=${concatStringsSep " " config.networking.nameservers}"}
        ${optionalString (cfg.fallbackDns != [])
          "FallbackDNS=${concatStringsSep " " cfg.fallbackDns}"}
        ${optionalString (cfg.domains != [])
          "Domains=${concatStringsSep " " cfg.domains}"}
        LLMNR=${cfg.llmnr}
        DNSSEC=${cfg.dnssec}
        DNSOverTLS=${cfg.dnsovertls}
        ${config.services.resolved.extraConfig}
      '';

      # symlink the dynamic stub resolver of resolv.conf as recommended by upstream:
      # https://www.freedesktop.org/software/systemd/man/systemd-resolved.html#/etc/resolv.conf
      "resolv.conf".source = "/run/systemd/resolve/stub-resolv.conf";
    } // optionalAttrs dnsmasqResolve {
      "dnsmasq-resolv.conf".source = "/run/systemd/resolve/resolv.conf";
    };

    # If networkmanager is enabled, ask it to interface with resolved.
    networking.networkmanager.dns = "systemd-resolved";

  };

}
