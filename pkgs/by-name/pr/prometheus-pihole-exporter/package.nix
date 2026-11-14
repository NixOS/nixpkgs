{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pihole-exporter";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "eko";
    repo = "pihole-exporter";
    rev = "v${version}";
    hash = "sha256-y/ACJ85gy3HnqZ/KZM4OvjdXv1CeYesJvzGCCZlgpQk=";
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
