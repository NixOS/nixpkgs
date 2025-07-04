{
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OtlYftOUC/eJfqZKZzlxQVUj9PfWsixeOvUhlwVmllM=";
      type = "gem";
    };
    version = "1.6.1";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/7BJefUeZAaCPAOr5Q4dosglxVo33uE4UYzdCdnTrqg=";
      type = "gem";
    };
    version = "1.7.5";
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
      hash = "sha256-jWFwJ5hyIBEG3hqEwnzEClcewlhAV6PDNbJyHnMmgz4=";
      type = "gem";
    };
    version = "0.10.0";
  };
}
