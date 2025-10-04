{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "do-agent";
  version = "3.18.3";

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "do-agent";
    rev = version;
    sha256 = "sha256-YYckleFnWt7Wttmkb20g5fs9DOoL9VNDmOWdP3qNstU=";
  };

  ldflags = [
    "-X main.version=${version}"
  ];

  vendorHash = null;

  doCheck = false;

  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system $src/packaging/etc/systemd/system/do-agent.service
  '';

  meta = with lib; {
    description = "DigitalOcean droplet system metrics agent";
    mainProgram = "do-agent";
    longDescription = ''
      do-agent is a program provided by DigitalOcean that collects system
      metrics from a DigitalOcean Droplet (on which the program runs) and sends
      them to DigitalOcean to provide resource usage graphs and alerting.
    '';
    homepage = "https://github.com/digitalocean/do-agent";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
