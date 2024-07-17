{
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "sha256-fPWiGi0w4OFlMZOIf3gd21jyeYhg5t/VdLz7kK9fD8Q=";
      type = "gem";
    };
    version = "1.5.1";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "sha256-H9BBOLbkqQAX6NG4BMA5AxOZhm/z+6u3girqNnx4YV0=";
      type = "gem";
    };
    version = "1.15.0";
  };
  neovim = {
    dependencies = [
      "msgpack"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "sha256-hRI43XGHGeqxMvpFjp0o79GGReiLXTkhwh5LYq6AQL4=";
      type = "gem";
    };
    version = "0.9.0";
  };
}
