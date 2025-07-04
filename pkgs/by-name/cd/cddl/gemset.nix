{
  abnc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Pb3GW6ekQgZ03anOjfVtnbtPFPy7kAa85ggInthLQHo=";
      type = "gem";
    };
    version = "0.1.1";
  };
  abnftt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-m/jC9Wq220im2Fp6ow+7+bLzv44nQyEBTNAL22fwKuU=";
      type = "gem";
    };
    version = "0.2.6";
  };
  base32 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y5gQq3x5hi7W6tJUs6RPolNdCIOWzUEu7zi9wgYFWro=";
      type = "gem";
    };
    version = "0.3.4";
  };
  base45_lite = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EYXk29g77Z463uGaqhvm5GVwM+pqV1aBQtoDsZYZnNg=";
      type = "gem";
    };
    version = "1.0.1";
  };
  cbor-canonical = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IVgp5AgJtmHKQMMrnWHiNL4l0gVLmwT41WmlVnQoEro=";
      type = "gem";
    };
    version = "0.1.2";
  };
  cbor-deterministic = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-at1mogz1J/6VsvvPD4GW+T1UkZL/dhkX7RS2YCt5NfA=";
      type = "gem";
    };
    version = "0.1.3";
  };
  cbor-diag = {
    dependencies = [
      "cbor-canonical"
      "cbor-deterministic"
      "cbor-packed"
      "json_pure"
      "neatjson"
      "treetop"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-B9k/+uZY11VOiEj9W3TDW/dHwr+9nlSvmw3uJ4fRrr8=";
      type = "gem";
    };
    version = "0.9.5";
  };
  cbor-packed = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NJizbQDc/GDFGSAmU1yjz+5O5ulODEcGTCPumI/0MrY=";
      type = "gem";
    };
    version = "0.1.5";
  };
  cddl = {
    dependencies = [
      "abnc"
      "abnftt"
      "base32"
      "base45_lite"
      "cbor-diag"
      "colorize"
      "json_pure"
      "regexp-examples"
      "scanf"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5Ir1aM/8nb6VFCxXeifkWHyxwPVMQIRd7EzKcdzeIaA=";
      type = "gem";
    };
    version = "0.12.9";
  };
  colorize = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MLUjfwYD9mYquNH8K9SpYUK4BsZBXXnkXvX9xqDPyDc=";
      type = "gem";
    };
    version = "1.1.0";
  };
  json_pure = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aod5KbqdT6CAjMw4ZW0bFdE4sqoKoyA37gWr6hNCes4=";
      type = "gem";
    };
    version = "2.8.1";
  };
  neatjson = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GsQyq0DFt+3lWRj8eK+ZZJTCS1HOPD6g9j8b6hGmoXI=";
      type = "gem";
    };
    version = "0.10.5";
  };
  polyglot = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WdZu9ePBZkMcOcuLfB0Cr0GQUTUvJ5EvakOYGz3vFq8=";
      type = "gem";
    };
    version = "0.3.5";
  };
  regexp-examples = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-O4lusR8Nobmtmv2mLhUrzcAH6iCzN5P+wFgYKz/j03E=";
      type = "gem";
    };
    version = "1.5.1";
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
  treetop = {
    dependencies = [ "polyglot" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Uit1oSi16j9bjuLAn2O5Zg7UJd65pGRMTGiTxdGrCk=";
      type = "gem";
    };
    version = "1.6.12";
  };
}
