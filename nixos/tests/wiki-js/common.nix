{ pkgs, ... }:
{
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.memorySize = 2047;
      services.wiki-js = {
        enable = true;
        settings.db.host = "/run/postgresql";
        settings.db.user = "wiki-js";
        settings.db.db = "wiki-js";
        settings.logLevel = "debug";
      };
      services.postgresql = {
        enable = true;
        ensureDatabases = [ "wiki-js" ];
        ensureUsers = [
          {
            name = "wiki-js";
            ensureDBOwnership = true;
          }
        ];
      };
      systemd.services.wiki-js = {
        requires = [ "postgresql.target" ];
        after = [ "postgresql.target" ];
      };
      environment.systemPackages = with pkgs; [ jq ];
    };
}
