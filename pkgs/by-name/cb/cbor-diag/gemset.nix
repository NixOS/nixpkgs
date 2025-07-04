{
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
      hash = "sha256-4UjtfuzJ7IL+nVrey9j+L1JR8akvBhhrQ3BCu90lCjA=";
      type = "gem";
    };
    version = "0.9.6";
  };
  cbor-packed = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Fk2bAURc8zkIJE+3q2BKR7LgKc9kOwIr7ufUEy74a2k=";
      type = "gem";
    };
    version = "0.2.2";
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
  treetop = {
    dependencies = [ "polyglot" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ujHRkRzlPbxoIIuea0IdSNFr/JlVHl77W8cbvI/HrtQ=";
      type = "gem";
    };
    version = "1.6.14";
  };
}
