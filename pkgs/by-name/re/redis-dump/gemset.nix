{
  drydock = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0grf3361mh93lczljmnwafl7gbcp9kk1bjpfwx4ykpd43fzdbfyj";
      type = "gem";
    };
    version = "0.6.9";
  };
  redis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rk6mmy3y2jd34llrf591ribl1p54ghkw7m96wrbamy8fwva5zqv";
      type = "gem";
    };
    version = "4.1.0";
  };
  redis-dump = {
    dependencies = [
      "drydock"
      "redis"
      "uri-redis"
      "yajl-ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gvip73kgm8xvyjmjkz4b986wni9blsmrnpvp5jrsxjz3g0sqzwg";
      type = "gem";
    };
    version = "0.4.0";
  };
  uri-redis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13n8ak41rikkbmml054pir4i1xbgjpmf3dbqihc2kcrgmz3dg81a";
      type = "gem";
    };
    version = "0.4.2";
  };
  yajl-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16v0w5749qjp13xhjgr2gcsvjv6mf35br7iqwycix1n2h7kfcckf";
      type = "gem";
    };
    version = "1.4.1";
  };
}
