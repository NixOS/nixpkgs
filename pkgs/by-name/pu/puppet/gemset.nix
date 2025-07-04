{
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gv3T+KCBbijVE+Y3uyuQpF17mCvfTzoFEXItLklYAeI=";
      type = "gem";
    };
    version = "1.2.3";
  };
  deep_merge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-g87To9f5X2felY0s5BsYdOg8jZT+Ldv/UMi0uCMjVjo=";
      type = "gem";
    };
    version = "1.2.2";
  };
  facter = {
    dependencies = [
      "hocon"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8CQQ5gIGIhlDDq+IHs6XxDsXxRlCvMo50Ke5iuXfLy4=";
      type = "gem";
    };
    version = "4.7.0";
  };
  fast_gettext = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AlPiZCPMq2gGHEI4eCfjuZJDobFa1hTfHIALqHDWT4Q=";
      type = "gem";
    };
    version = "2.3.0";
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
  locale = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ui+Zc+8+7mSqybygbSHbL7pnX6PSz2HSH0LRyhip94A=";
      type = "gem";
    };
    version = "2.1.4";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-H9BBOLbkqQAX6NG4BMA5AxOZhm/z+6u3girqNnx4YV0=";
      type = "gem";
    };
    version = "1.15.0";
  };
  puppet = {
    dependencies = [
      "concurrent-ruby"
      "deep_merge"
      "facter"
      "fast_gettext"
      "locale"
      "multi_json"
      "puppet-resource_api"
      "scanf"
      "semantic_puppet"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aRSSyTBNawJ0ReaYdNppRJ/MTyo/Bwfyre4XiK8OKq0=";
      type = "gem";
    };
    version = "8.6.0";
  };
  puppet-resource_api = {
    dependencies = [ "hocon" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-S4Lnf60dOBDzqErXJ6qf18TosRebrMA06QccCo8uvmc=";
      type = "gem";
    };
    version = "1.9.0";
  };
  scanf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Uz239+Wsr+oaFF1sUynO9melj7y31kN5qAj/EZnuGwA=";
      type = "gem";
    };
    version = "1.0.0";
  };
  semantic_puppet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UtEI0I4aXZXAA0PLOkk2+x3uz/K+YS7DnJy2a+WouFk=";
      type = "gem";
    };
    version = "1.1.0";
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
