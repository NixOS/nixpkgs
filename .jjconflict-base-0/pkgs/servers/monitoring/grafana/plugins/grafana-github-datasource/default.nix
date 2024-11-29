{ grafanaPlugin, lib }:

grafanaPlugin rec {
  pname = "grafana-github-datasource";
  version = "1.9.0";
  zipHash = {
    x86_64-linux = "sha256-DQKb8VKa41bL6D9DN8OpL3sqBIlRCa1zgIjduD6AcQc=";
    aarch64-linux = "sha256-RHFURMnBF14QCZhVxZQO3JJ3OP6JXD2Hfef8IyVOgBs=";
    x86_64-darwin = "sha256-UBwc8CZRRHsEKpzTgn5PNXjxLzETyWKGsDFtXZnkRW4=";
    aarch64-darwin = "sha256-xgQ7s3QP7Sq8ni0n54NE/nYlyALIESfXNKncruAWty0=";
  };
  meta = with lib; {
    description = "The GitHub datasource allows GitHub API data to be visually represented in Grafana dashboards.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
  };
}
