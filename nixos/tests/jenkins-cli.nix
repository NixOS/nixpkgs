{ pkgs, ... }:
{
  name = "jenkins-cli";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ pamplemousse ];
  };

  nodes = {
    machine =
      { ... }:
      {
        services.jenkins = {
          enable = true;
          withCLI = true;
        };
      };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("jenkins")

    assert "JENKINS_URL" in machine.succeed("env")
    assert "http://0.0.0.0:8080" in machine.succeed("echo $JENKINS_URL")

    machine.succeed(
        "jenkins-cli -auth admin:$(cat /var/lib/jenkins/secrets/initialAdminPassword)"
    )
  '';
}
