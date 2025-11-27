{
  name = "systemd-resolved-dnssd";
  meta.maintainers = [ ];

  nodes.responder = {
    services.resolved.enable = true;
    services.resolved.settings.Resolve.MulticastDNS = "true";
    services.resolved.openFirewallMdns = true;
    services.resolved.dnssd = {
      name.Service = {
        Type = "_http._tcp";
        Port = 80;
        TxtText = [
          "ok=yes"
          "bad\t\n\r \"\\=strings\t\n\r \"\\"
          "unicode=é_é"
        ];
      };
    };
  };

  nodes.querier = {
    services.resolved.enable = true;
    services.resolved.settings.Resolve.MulticastDNS = "true";
    services.resolved.openFirewallMdns = true;
  };

  testScript = ''
    start_all()
    responder.wait_for_unit("multi-user.target")
    querier.wait_for_unit("multi-user.target")

    query = querier.succeed("resolvectl service name._http._tcp.local")
    assert "responder.local" in query
    assert "ok=yes" in query
  '';
}
