{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "do-agent";
<<<<<<< HEAD
  version = "3.18.7";
=======
  version = "3.18.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "do-agent";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-0subv3u+iO409GiHA9HaWUAo21F2hgmQnNaOPbPXKiU=";
=======
    sha256 = "sha256-9JYDxHtrJn20QIcV4OHySzrwx9jRJyqx3WYfxoJX4Hw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  ldflags = [
    "-X main.version=${version}"
  ];

  vendorHash = null;

  doCheck = false;

  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system $src/packaging/etc/systemd/system/do-agent.service
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "DigitalOcean droplet system metrics agent";
    mainProgram = "do-agent";
    longDescription = ''
      do-agent is a program provided by DigitalOcean that collects system
      metrics from a DigitalOcean Droplet (on which the program runs) and sends
      them to DigitalOcean to provide resource usage graphs and alerting.
    '';
    homepage = "https://github.com/digitalocean/do-agent";
<<<<<<< HEAD
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
=======
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
