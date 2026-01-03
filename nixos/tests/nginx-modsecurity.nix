{ ... }:
{
  name = "nginx-modsecurity";

  nodes.machine =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.nginx = {
        enable = true;
        additionalModules = [ pkgs.nginxModules.modsecurity ];
        virtualHosts.localhost =
          let
            modsecurity_conf = pkgs.writeText "modsecurity.conf" ''
              SecRuleEngine On
              SecDefaultAction "phase:1,log,auditlog,deny,status:403"
              SecDefaultAction "phase:2,log,auditlog,deny,status:403"
              SecRule REQUEST_METHOD   "HEAD"        "id:100, phase:1, block"
              SecRule REQUEST_FILENAME "secret.html" "id:101, phase:2, block"
            '';
            testroot = pkgs.runCommand "testroot" { } ''
              mkdir -p $out
              echo "<html><body>Hello World!</body></html>" > $out/index.html
              echo "s3cret" > $out/secret.html
            '';
          in
          {
            root = testroot;
            extraConfig = ''
              modsecurity on;
              modsecurity_rules_file ${modsecurity_conf};
            '';
          };
      };
    };
  testScript = ''
    machine.wait_for_unit("nginx")

    response = machine.wait_until_succeeds("curl -fvvv -s http://127.0.0.1/")
    assert "Hello World!" in response

    machine.fail("curl -fvvv -X HEAD -s http://127.0.0.1/")
    machine.fail("curl -fvvv -s http://127.0.0.1/secret.html")
  '';
}
