{
  data_uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-frL2NIfMuUP64OylYXKcSNTVZU12+DMKoW7R3Nvr8zs=";
      type = "gem";
    };
    version = "0.1.0";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-by7S+mgEeWLWByuWRCDLqR2Czm+o7iUZUMF/ymrzwqA=";
      type = "gem";
    };
    version = "1.15.5";
  };
  ffi-rzmq = {
    dependencies = [ "ffi-rzmq-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L+s7xb9G32M+IhFRSsQIUh3wwZj1QTT9s4MiZ12fRZE=";
      type = "gem";
    };
    version = "2.0.7";
  };
  ffi-rzmq-core = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZUFiWg+AAW5MsbIqaLOHC9cRww3n13Yl2NbJK+lesyo=";
      type = "gem";
    };
    version = "1.0.7";
  };
  io-console = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zp2aNFW+SMVsrGW4737FmwdSY0OQX5/aE4eRAFtWMzY=";
      type = "gem";
    };
    version = "0.6.0";
  };
  irb = {
    dependencies = [ "reline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yA4rJZ+NInetquS8mg5tD1qdlXjBoVcothgPOUFQDJU=";
      type = "gem";
    };
    version = "1.7.4";
  };
  iruby = {
    dependencies = [
      "data_uri"
      "ffi-rzmq"
      "irb"
      "mime-types"
      "multi_json"
      "native-package-installer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zCGeKseXw/v4wrk37n0mVHcjyK4OWtZfKXWqMyWzpiA=";
      type = "gem";
    };
    version = "0.7.4";
  };
  mime-types = {
    dependencies = [ "mime-types-data" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hddy+2zyH5mayAhZmBkvud1dFuhuxMacXnmsMANCDWE=";
      type = "gem";
    };
    version = "3.5.1";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qthWY9Jgfh9LhOS2qs/3i6NzO7lY7pMYkgXmP0+N7Z8=";
      type = "gem";
    };
    version = "3.2023.0808";
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
  native-package-installer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y6Y/uU3+RYJ1msxTtbWodCnsA817edLCE6kqBnvqnAA=";
      type = "gem";
    };
    version = "1.1.8";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-i6IUpTy2UiTTnNYjzOazXbVTxxGwwFF1xcQO88+2YVM=";
      type = "gem";
    };
    version = "0.3.8";
  };
}
