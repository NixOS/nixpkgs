{
  lib,
  fetchTraefikPlugin,
}:

fetchTraefikPlugin {
  plugin = "badger";
  owner = "fosrl";
  version = "1.2.0";
  hash = "sha256-j6XCWW0Z9ZWoE2CQP4oNoJ/V7jgizwsY629ZiyMxhfY=";

  meta = {
    description = "Traefik plugin that handles authentication for Pangolin resources";
    homepage = "https://plugins.traefik.io/plugins/676da7c6eaa878daeef9c7e9/fossorial-badger";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jackr
      sigmasquadron
    ];
  };
}
