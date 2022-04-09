import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "tomcat";

  nodes.machine = { pkgs, ... }: {
    services.tomcat.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("tomcat.service")
    machine.wait_for_open_port(8080)
    machine.wait_for_file("/var/tomcat/webapps/examples");
    machine.succeed(
        "curl --fail http://localhost:8080/examples/servlets/servlet/HelloWorldExample | grep 'Hello World!'"
    )
    machine.succeed(
        "curl --fail http://localhost:8080/examples/jsp/jsp2/simpletag/hello.jsp | grep 'Hello, world!'"
    )
  '';
})
