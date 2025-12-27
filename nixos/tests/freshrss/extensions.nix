{
  name = "freshrss-extensions";

  nodes.machine =
    { pkgs, ... }:
    {
      services.freshrss = {
        enable = true;
        baseUrl = "http://localhost";
        passwordFile = pkgs.writeText "password" "secret";
        extensions = [
          pkgs.freshrss-extensions.title-wrap
          pkgs.freshrss-extensions.unsafe-auto-login
          pkgs.freshrss-extensions.youtube
        ];
      };
    };
  extraPythonPackages = p: [
    p.lxml
    p.types-lxml
  ];

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_open_port(80)
    response = machine.succeed("curl --fail-with-body --silent http://localhost:80/i/?c=extension")
    assert '<span class="ext_name disabled">YouTube Video Feed</span>' in response, "Extension not present in extensions page."

    # enable Title-Wrap extension
    from lxml import etree
    tree = etree.HTML(response)
    csrf = tree.xpath("/html/body/header/nav/form/input/@value")[0]
    response = machine.succeed(f"curl --fail-with-body --silent 'http://localhost:80/i/?c=extension&a=enable&e=Title-Wrap' -d '_csrf={csrf}'")
    # verify that the Title-Wrap css is accessible.
    machine.succeed("curl --fail-with-body --silent 'http://localhost:80/ext.php?1=&f=xExtension-TitleWrap/static/title_wrap.css'")
  '';
}
