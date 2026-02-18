{
  lib,
  fetchTraefikPlugin,
}:

fetchTraefikPlugin {
  plugin = "geoblock";
  owner = "PascalMinder";
  version = "0.3.3";
  hash = "sha256-gLhihjsBJEKGzpIwWzu/zmvLJbqnqXsF8ZiJWWKwDIA=";

  meta = {
    description = "Traefik plugin that denies requests based on country of origin";
    homepage = "https://plugins.traefik.io/plugins/62d6ce04832ba9805374d62c/geo-block";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jackr
      sigmasquadron
    ];
  };
}
