{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "do-agent";
  version = "3.18.8";

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "do-agent";
    rev = finalAttrs.version;
    sha256 = "sha256-uOZTiP+2r5wTPuYXcPc3bShfTIlQMkcfwiuBqUeLxPA=";
  };

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  vendorHash = null;

  doCheck = false;

  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system $src/packaging/etc/systemd/system/do-agent.service
  '';

  meta = {
    description = "DigitalOcean droplet system metrics agent";
    mainProgram = "do-agent";
    longDescription = ''
      do-agent is a program provided by DigitalOcean that collects system
      metrics from a DigitalOcean Droplet (on which the program runs) and sends
      them to DigitalOcean to provide resource usage graphs and alerting.
    '';
    homepage = "https://github.com/digitalocean/do-agent";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
