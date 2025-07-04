{
  kramdown = {
    dependencies = [ "rexml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ti5by9bqIMemcw67sqEHI3hW4U8pzr9bEMh2zBokgcU=";
      type = "gem";
    };
    version = "2.4.0";
  };
  kramdown-parser-gfm = {
    dependencies = [ "kramdown" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+zl0VRZCfSmIVDvwH8TPCrEUlHY4I5Pg6cSFkvZYFyk=";
      type = "gem";
    };
    version = "1.1.0";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ejfbiudYCGw8OsOlnANnBNMx6WXV4QZjXkpC1uZgic4=";
      type = "gem";
    };
    version = "2.8.5";
  };
  mustache = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kIkf3VC1ORnKM0yMEDHq2hIV540ibVeV5SPWEjonF9A=";
      type = "gem";
    };
    version = "1.1.1";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NBOIGE6XXQkebjjOPzsziL+35Kw9eQ79jjkSSEQEC9E=";
      type = "gem";
    };
    version = "1.16.0";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-t4WrijDsQ7zgc8Udu+eR/ScAD2jRyZbJXamL9oUxaQU=";
      type = "gem";
    };
    version = "1.7.3";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4GaaLU6fEJlRyx/ecj2KzShUJdgVlKLqkpMEr1AoKBY=";
      type = "gem";
    };
    version = "3.2.6";
  };
  ronn-ng = {
    dependencies = [
      "kramdown"
      "kramdown-parser-gfm"
      "mustache"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TusBhcD7+oie/tkjtbUOlJzYaefYKsdBOKzQyccWXsA=";
      type = "gem";
    };
    version = "0.10.1";
  };
}
