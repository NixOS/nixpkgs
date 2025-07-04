{
  ansi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VAglMnTjPZ0n1KmMRtKZgmb9Uculin650I9Q5X7SNZI=";
      type = "gem";
    };
    version = "1.5.0";
  };
  chronic = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dm8vzOasPMFSJJ7Q8rgndw0+UX4uh8X7p+109IidLcM=";
      type = "gem";
    };
    version = "0.10.2";
  };
  papertrail = {
    dependencies = [
      "ansi"
      "chronic"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Huouk8AZvcHrxbtMjNR+yTHsCQhI9rQYkfy+DNWDH5w=";
      type = "gem";
    };
    version = "0.11.2";
  };
}
