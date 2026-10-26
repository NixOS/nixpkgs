{ hostPkgs, lib, ... }:
{
  _class = "nixosTest";
  name = "ghostunnel";
  nodes = {
    backend =
      { pkgs, ... }:
      {
        services.nginx.enable = true;
        services.nginx.virtualHosts."backend".root = pkgs.runCommand "webroot" { } ''
          mkdir $out
          echo hi >$out/hi.txt
        '';
        networking.firewall.allowedTCPPorts = [ 80 ];
      };
    service =
      { pkgs, ... }:
      {
        system.services."ghostunnel-plain-old" = {
          imports = [ pkgs.ghostunnel.services.default ];
          ghostunnel = {
            listen = "0.0.0.0:443";
            cert = "/root/service-cert.pem";
            key = "/root/service-key.pem";
            disableAuthentication = true;
            target = "backend:80";
            unsafeTarget = true;
          };
        };
        system.services."ghostunnel-client-cert" = {
          imports = [ pkgs.ghostunnel.services.default ];
          ghostunnel = {
            listen = "0.0.0.0:1443";
            cert = "/root/service-cert.pem";
            key = "/root/service-key.pem";
            cacert = "/root/ca.pem";
            target = "backend:80";
            allowCN = [ "client" ];
            unsafeTarget = true;
          };
        };
        # A service for each value of the landlock option.
        system.services."ghostunnel-required-missing-path" = {
          imports = [ pkgs.ghostunnel.services.default ];
          ghostunnel = {
            listen = "localhost:2443";
            cert = "/root/service-cert.pem";
            key = "/root/service-key.pem";
            disableAuthentication = true;
            target = "backend:80";
            unsafeTarget = true;
            extraArguments = [ "--landlock-allow-read=/missing" ];
          };
        };
        system.services."ghostunnel-best-effort-missing-path" = {
          imports = [ pkgs.ghostunnel.services.default ];
          ghostunnel = {
            listen = "localhost:3443";
            cert = "/root/service-cert.pem";
            key = "/root/service-key.pem";
            disableAuthentication = true;
            target = "backend:80";
            unsafeTarget = true;
            landlock = "best-effort";
            extraArguments = [ "--landlock-allow-read=/missing" ];
          };
        };
        system.services."ghostunnel-disabled" = {
          imports = [ pkgs.ghostunnel.services.default ];
          ghostunnel = {
            listen = "localhost:4443";
            cert = "/root/service-cert.pem";
            key = "/root/service-key.pem";
            disableAuthentication = true;
            target = "backend:80";
            unsafeTarget = true;
            landlock = "disabled";
          };
        };
        networking.firewall.allowedTCPPorts = [
          443
          1443
        ];
      };
    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.curl
        ];
      };
  };

  testScript = ''
    import subprocess

    # prepare certificates

    def cmd(command):
      print(f"+{command}")
      r = subprocess.run(command, shell=True).returncode
      if r != 0:
        raise Exception(f"Command {command} failed with exit code {r}")

    # Create CA
    cmd("${hostPkgs.openssl}/bin/openssl genrsa -out ca-key.pem 4096")
    cmd("${hostPkgs.openssl}/bin/openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -subj '/C=NL/ST=Zuid-Holland/L=The Hague/O=Stevige Balken en Planken B.V./OU=OpSec/CN=Certificate Authority' -out ca.pem")

    # Create service
    cmd("${hostPkgs.openssl}/bin/openssl genrsa -out service-key.pem 4096")
    cmd("${hostPkgs.openssl}/bin/openssl req -subj '/CN=service' -sha256 -new -key service-key.pem -out service.csr")
    cmd("echo subjectAltName = DNS:service,IP:127.0.0.1 >> extfile.cnf")
    cmd("echo extendedKeyUsage = serverAuth >> extfile.cnf")
    cmd("${hostPkgs.openssl}/bin/openssl x509 -req -days 365 -sha256 -in service.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out service-cert.pem -extfile extfile.cnf")

    # Create client
    cmd("${hostPkgs.openssl}/bin/openssl genrsa -out client-key.pem 4096")
    cmd("${hostPkgs.openssl}/bin/openssl req -subj '/CN=client' -new -key client-key.pem -out client.csr")
    cmd("echo extendedKeyUsage = clientAuth > extfile-client.cnf")
    cmd("${hostPkgs.openssl}/bin/openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -extfile extfile-client.cnf")

    cmd("ls -al")

    start_all()

    # Configuration
    service.copy_from_host("ca.pem", "/root/ca.pem")
    service.copy_from_host("service-cert.pem", "/root/service-cert.pem")
    service.copy_from_host("service-key.pem", "/root/service-key.pem")
    client.copy_from_host("ca.pem", "/root/ca.pem")
    client.copy_from_host("service-cert.pem", "/root/service-cert.pem")
    client.copy_from_host("client-cert.pem", "/root/client-cert.pem")
    client.copy_from_host("client-key.pem", "/root/client-key.pem")

    backend.wait_for_unit("nginx.service")
    service.wait_for_unit("multi-user.target")
    service.wait_for_unit("multi-user.target")
    client.wait_for_unit("multi-user.target")

    # The servers start before the certificates are copied, and retry only
    # every 5 seconds. Restart them now that the files exist.
    service.succeed("systemctl reset-failed && systemctl restart ghostunnel-plain-old ghostunnel-client-cert ghostunnel-required-missing-path ghostunnel-best-effort-missing-path ghostunnel-disabled")
    service.wait_for_open_port(443)
    service.wait_for_open_port(1443)
    service.wait_for_open_port(3443)
    service.wait_for_open_port(4443)

    # Check assumptions before the real test
    client.succeed("bash -c 'diff <(curl -v --no-progress-meter http://backend/hi.txt) <(echo hi)'")

    # Plain old simple TLS can connect, ignoring cert
    client.succeed("bash -c 'diff <(curl -v --no-progress-meter --insecure https://service/hi.txt) <(echo hi)'")

    # Plain old simple TLS provides correct signature with its cert
    client.succeed("bash -c 'diff <(curl -v --no-progress-meter --cacert /root/ca.pem https://service/hi.txt) <(echo hi)'")

    # Client can authenticate with certificate
    client.succeed("bash -c 'diff <(curl -v --no-progress-meter --cert /root/client-cert.pem --key /root/client-key.pem --cacert /root/ca.pem https://service:1443/hi.txt) <(echo hi)'")

    # Each server has set up its landlock sandbox. Ghostunnel logs its
    # landlock messages before it listens, so after the requests above the
    # journal has all of them.
    failures = [
      "unable to set up landlock",
      # Without landlock, ghostunnel exits with this message. Without landlock
      # network rules, it logs this message as a note and runs without them.
      "kernel does not support landlock",
      # Below ABI 6, the sandbox lacks some restrictions.
      "the landlock sandbox is incomplete",
    ]
    for failure in failures:
      # Sanity check: message occurs in source, so it can plausibly be logged.
      cmd(f"${hostPkgs.gnugrep}/bin/grep --recursive --quiet --fixed-strings '{failure}' ${hostPkgs.srcOnly hostPkgs.ghostunnel}")
    setup = "setting up landlock rules to limit process privileges"
    service.succeed("journalctl --sync")
    for unit in ["ghostunnel-plain-old", "ghostunnel-client-cert"]:
      invocation = service.succeed(f"systemctl show --property InvocationID --value {unit}").strip()
      journal = f"journalctl _SYSTEMD_INVOCATION_ID={invocation}"
      service.succeed(f"{journal} --grep '{setup}'")
      for failure in failures:
        # journalctl exits with 1 when no entry matches, and also on errors.
        # An error also fails the grep above, which reads the same journal.
        service.succeed(f"rc=0; {journal} --grep '{failure}' || rc=$?; test $rc = 1")

    def grep_journal(unit, needle):
      return f"journalctl --unit {unit} --output cat | grep --fixed-strings '{needle}'"

    missing_path_error = 'unable to set up landlock: populating ruleset for "/missing" with access {read_file,read_dir}: open: no such file or directory'

    # "required" exits.
    service.wait_until_succeeds(grep_journal("ghostunnel-required-missing-path", f"error: {missing_path_error}"))

    # "best-effort" runs without the sandbox, which is why it listens.
    service.succeed(grep_journal("ghostunnel-best-effort-missing-path", f"warning: {missing_path_error}"))

    # "disabled" does not set up the sandbox. grep exits with 1 when no line
    # matches. The servers above share the needle, so a typo fails there.
    service.succeed(f"rc=0; {grep_journal('ghostunnel-disabled', setup)} || rc=$?; test $rc = 1")

    # Client must authenticate with certificate
    client.fail("bash -c 'diff <(curl -v --no-progress-meter --cacert /root/ca.pem https://service:1443/hi.txt) <(echo hi)'")
  '';

  meta.maintainers = with lib.maintainers; [
    roberth
  ];
}
