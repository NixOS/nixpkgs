{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pihole-exporter";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "eko";
    repo = "pihole-exporter";
    rev = "v${version}";
    sha256 = "sha256-lKBYOPZOriLQql9iOXJa1BvHNu1Bt60/F6BoHUxdoHs=";
  };

  vendorHash = "sha256-qAcxX4yIyd/fWsJ4CM0QEn+f7JAeY1LgUr3aGE+SAPM=";

  meta = {
    description = "Prometheus exporter for PI-Hole's Raspberry PI ad blocker";
    mainProgram = "pihole-exporter";
    homepage = "https://github.com/eko/pihole-exporter";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
