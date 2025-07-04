{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RimGU3zzc1q188D1V/FBVdd49LQ+pPSFqd65yPfFgjI=";
      type = "gem";
    };
    version = "2.8.7";
  };
  childprocess = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mo1IS+L9QJag6QoM0+RJoFvDqjP4rJ5Nbc72rBRVtuw=";
      type = "gem";
    };
    version = "5.1.0";
  };
  cri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ir/pJO9T53Ko5O6QfnkdO/z8p4vGKlhZ47mJm6KZVuU=";
      type = "gem";
    };
    version = "2.15.12";
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
  diff-lcs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JzIj37QGhVSENtMrRzOqZzUXacfepiHafZ3UgT5j3f4=";
      type = "gem";
    };
    version = "1.5.1";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UWMOQ0JQeDEcBWynX5Ybs72hZBqzbkStTEVeCw5KIxw=";
      type = "gem";
    };
    version = "1.17.0";
  };
  hitimes = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DovFgpJRu0O+OkTlUQ39TVzE+uURK/HRsJFnndPNqUc=";
      type = "gem";
    };
    version = "2.0.0";
  };
  json-schema = {
    dependencies = [ "addressable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1eaNwyuUQI0LBq0E+Tgsy7b+WkSRDgZvhUf1bEcaeCU=";
      type = "gem";
    };
    version = "4.3.1";
  };
  json_pure = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-w5GFqkHAShkzuNZtEpQiR0MmLuaIGtx7WkiKsq4Zx04=";
      type = "gem";
    };
    version = "2.6.3";
  };
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
  minitar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Oh27roxMjmerjjlRujbLk7hEwiWyn4PjuQ9IIm89YDg=";
      type = "gem";
    };
    version = "0.12.1";
  };
  pastel = {
    dependencies = [ "tty-color" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SB2p+30vbmsaCPrxH6EDYxctxA/UeEjwlq4hIJ+AWnU=";
      type = "gem";
    };
    version = "0.8.0";
  };
  pathspec = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xOf/TEAZSZSIh04hw3oeJHPVEjz85vE+ywf0LA+MXSM=";
      type = "gem";
    };
    version = "1.1.3";
  };
  pdk = {
    dependencies = [
      "childprocess"
      "cri"
      "deep_merge"
      "diff-lcs"
      "ffi"
      "hitimes"
      "json-schema"
      "json_pure"
      "minitar"
      "pathspec"
      "puppet-modulebuilder"
      "tty-prompt"
      "tty-spinner"
      "tty-which"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BgSGFk+rMPTVq3vY83BsaTkL8UINaVVQ4V6NGC1rNL4=";
      type = "gem";
    };
    version = "3.3.0";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YdROHKtcu75bMQaEgc8Wl23Q3BtrB72VYX74xePgDG8=";
      type = "gem";
    };
    version = "6.0.1";
  };
  puppet-modulebuilder = {
    dependencies = [
      "minitar"
      "pathspec"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-44QzxhkJYA1EsDVDUYAaK+pVLE32dDZQa21aIjAMA2Y=";
      type = "gem";
    };
    version = "1.1.0";
  };
  tty-color = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b5w3yjpOI2f7Lm0JcidiZH1vRVwRHwW1nzVzDuskMyo=";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-cursor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eVNBheand4iNiGKLFLah/fUVSmA/KF+AsXU+GQjgv0g=";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-prompt = {
    dependencies = [
      "pastel"
      "tty-reader"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/NvOkFI4mT8n7s/fZ1l6Y2vIOdkhkvag7vIrgWZEnsg=";
      type = "gem";
    };
    version = "0.23.1";
  };
  tty-reader = {
    dependencies = [
      "tty-cursor"
      "tty-screen"
      "wisper"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xilyyYXAsVZvDlZ0O2p4gvl509wy/0ke1JCgdviZwrE=";
      type = "gem";
    };
    version = "0.9.0";
  };
  tty-screen = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wJBlIRW+rnZDNsKIAtYz8gT7hNqTxqloql2OMZ6Bm1A=";
      type = "gem";
    };
    version = "0.8.2";
  };
  tty-spinner = {
    dependencies = [ "tty-cursor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DgNvBHtP+2HyqkX1p3DsALTQQTBTFVipS/xbGStXBUI=";
      type = "gem";
    };
    version = "0.9.3";
  };
  tty-which = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WCQFXw1nRMl+fEQmVE8B1RnEDRgG7y70fZhUR3mT9GY=";
      type = "gem";
    };
    version = "0.5.0";
  };
  wisper = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zhe8XDoWbyQaLmYThIsCXIFG/OLe+6UFkgwdHz+I+uY=";
      type = "gem";
    };
    version = "2.0.1";
  };
}
