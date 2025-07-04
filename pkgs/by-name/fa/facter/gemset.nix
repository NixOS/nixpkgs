{
  facter = {
    dependencies = [
      "hocon"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-t4ohO5Fgze16uT58R8ADxhjr1JxuylSdCaBo4nowpZ0=";
      type = "gem";
    };
    version = "4.10.0";
  };
  hocon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5xAj7XxWrngOw0wM53iaIzvOrQjARdULx7OvQPWvzYA=";
      type = "gem";
    };
    version = "1.4.0";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L5PGUoKMup/PT2X13IwwbxpzF+BarVg1oTdAEiwX8kw=";
      type = "gem";
    };
    version = "1.2.2";
  };
}
