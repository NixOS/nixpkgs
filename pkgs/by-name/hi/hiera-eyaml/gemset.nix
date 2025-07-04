{
  hiera-eyaml = {
    dependencies = [
      "highline"
      "optimist"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KNAXxkb6hna1YggJWjUHLBKCxWLnSQ2o9A/v6LntORE=";
      type = "gem";
    };
    version = "3.0.0";
  };
  highline = {
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wTYpju6Gzv+Huq3HHXZOoHmG+JgFY25KajBbLV2gdRk=";
      type = "gem";
    };
    version = "1.6.21";
  };
  optimist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kki2O+ZO4VFvLhodmNhShXHrKkg5nhkYjbHYZcfNXRY=";
      type = "gem";
    };
    version = "3.0.0";
  };
}
