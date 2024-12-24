{
  chronic = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hrdkn4g8x7dlzxwb1rfgr8kw3bp4ywg5l4y4i9c2g5cwv62yvvn";
      type = "gem";
    };
    version = "0.10.2";
  };
  deep_merge = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q3picw7zx1xdkybmrnhmk2hycxzaa0jv4gqrby1s90dy5n7fmsb";
      type = "gem";
    };
    version = "1.2.1";
  };
  doing = {
    dependencies = [
      "chronic"
      "deep_merge"
      "gli"
      "haml"
      "json"
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1y42yc7h45sz9hqj3g1dd77ipx58l7v64i7mrsj3is2f5rszd1rv";
      type = "gem";
    };
    version = "1.0.10pre";
  };
  gli = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g7g3lxhh2b4h4im58zywj9vcfixfgndfsvp84cr3x67b5zm4kaq";
      type = "gem";
    };
    version = "2.17.1";
  };
  haml = {
    dependencies = [ "tilt" ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l9zhfdk9z7xjfdp108r9fw4xa55hflin7hh3lpafbf9bdz96knr";
      type = "gem";
    };
    version = "4.0.3";
  };
  json = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qmj7fypgb9vag723w1a49qihxrcf5shzars106ynw2zk352gbv5";
      type = "gem";
    };
    version = "1.8.6";
  };
  tilt = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0020mrgdf11q23hm1ddd6fv691l51vi10af00f137ilcdb2ycfra";
      type = "gem";
    };
    version = "2.0.8";
  };
}
