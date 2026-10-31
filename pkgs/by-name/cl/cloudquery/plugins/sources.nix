{
  buildOfficialPlugin,
  fetchOfficialPlugin,
}:

# Source plugins for CloudQuery
{
  aws = buildOfficialPlugin (fa: {
    pluginType = "source";
    pluginName = "aws";
    # Versions after 22.19.2 are paid and cannot be pulled from GitHub
    version = "22.19.2";
    src = fetchOfficialPlugin {
      inherit (fa) pluginType pluginName version;
      hash = "sha256-oEBGTbU2ppLN7vwNtCYKqHUm8UE6OG5TnKYbLdS2B4w=";
    };
    vendorHash = "sha256-jDyotlJAma899o4E3/0+EJ8VoAudiYvTgE0q1zrKccg=";
    preBuild = ''
      rm -rf ./views/athena
    '';
    doCheck = false;
    meta = {
      description = "AWS source plugin for CloudQuery";
    };
  });
}
