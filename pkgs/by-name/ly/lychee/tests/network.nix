{
  config,
  hostPkgs,
  lib,
  ...
}:
let
  sitePkg = hostPkgs.runCommand "site" { } ''
    dist=$out/dist
    mkdir -p $dist
    echo "<html><body><a href=\"http://example/foo.html\">foo</a></body></html>" > $dist/index.html
    echo "<html><body><a href=\".\">index</a></body></html>" > $dist/foo.html
  '';
  check = config.node.pkgs.testers.lycheeLinkCheck {
    site = sitePkg;
  };
  checkJson = config.node.pkgs.testers.lycheeLinkCheck {
    site = sitePkg;
    extraArgs = [
      "--format"
      "json"
    ];
  };
in
{
  name = "testers-lychee-link-check-run";
  nodes.client =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.jq ];
    };
  nodes.example = {
    networking.firewall.allowedTCPPorts = [ 80 ];
    services.nginx = {
      enable = true;
      virtualHosts."example" = {
        locations."/" = {
          root = "/var/www/example";
          index = "index.html";
        };
      };
    };

  };
  testScript = ''
    start_all()

    # SETUP

    example.succeed("""
        mkdir -p /var/www/example
        echo '<h1>hi</h1>' > /var/www/example/index.html
    """)
    client.wait_until_succeeds("""
        curl --fail -v http://example
    """)

    # TEST CASES

    with subtest("online check detects broken links"):
        client.succeed("""
            exec 1>&2
            r=0
            ${lib.getExe check.online} || {
              r=$?
            }
            if [[ $r -ne 2 ]]; then
                echo "lycheeLinkCheck unexpected exit code $r"
                exit 1
            fi
        """)

    with subtest("online check succeeds when links are fixed"):
        example.succeed("""
            echo '<h1>foo</h1>' > /var/www/example/foo.html
        """)

        client.succeed("""
            ${lib.getExe check.online}
        """)

    with subtest("extraArgs are passed to the online wrapper"):
        client.succeed("""
            ${lib.getExe checkJson.online} --output /tmp/lychee.json
            jq -e .total /tmp/lychee.json
        """)
  '';
}
