{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.resolved;
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
      example = [ "example.com" ];
      type = types.listOf types.str;
      description = ''
        A list of domains. These domains are used as search suffixes
        when resolving single-label host names (domain names which
        contain no dot), in order to qualify them into fully-qualified
        domain names (FQDNs).
        </para><para>
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
        </para><para>
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

    services.resolved.extraConfig = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Extra config to append to resolved.conf.
      '';
    };

  };

  config = mkIf cfg.enable {

    systemd.additionalUpstreamSystemUnits = [
      "systemd-resolved.service"
    ];

    systemd.services.systemd-resolved = {
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."systemd/resolved.conf".source ];
    };

    environment.etc."systemd/resolved.conf".text = ''
      [Resolve]
      ${optionalString (config.networking.nameservers != [])
        "DNS=${concatStringsSep " " config.networking.nameservers}"}
      ${optionalString (cfg.fallbackDns != [])
        "FallbackDNS=${concatStringsSep " " cfg.fallbackDns}"}
      ${optionalString (cfg.domains != [])
        "Domains=${concatStringsSep " " cfg.domains}"}
      LLMNR=${cfg.llmnr}
      DNSSEC=${cfg.dnssec}
      ${config.services.resolved.extraConfig}
    '';

  };

}
