{
  abnc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yj09gc9w208wsy0d45vzha4zfwxdpsqvkm9vms0chm4lxdwdg9x";
      type = "gem";
    };
    version = "0.1.1";
  };
  abnftt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08k659idrl977g1anlff32g9cp3rykjvk05n4nifr8jxzdczzv0r";
      type = "gem";
    };
    version = "0.2.10";
  };
  base32 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fjs0l3c5g9qxwp43kcnhc45slx29yjb6m6jxbb2x1krgjmi166b";
      type = "gem";
    };
    version = "0.3.4";
  };
  base45_lite = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1n4w36bb20ys8a0mcmvax8rp0rg4wqdsm6p1vqx9xv9vv3dy918i";
      type = "gem";
    };
    version = "1.0.1";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01qml0yilb9basf7is2614skjp8384h2pycfx86cr8023arfj98g";
      type = "gem";
    };
    version = "0.2.0";
  };
  cbor-canonical = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fhj51s5d9b9spw096sb0p92bgilw9hrsay383563dh913j2jn11";
      type = "gem";
    };
    version = "0.1.2";
  };
  cbor-deterministic = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w1mg4mn1dhlxlbijxpzja8m8ggrjs0hzkzvnaazw9zm1ji6dpba";
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
      sha256 = "1psh00k5s19yhxajskdqlxfamyf1piriyzm1nrcjlqcjl0863j8l";
      type = "gem";
    };
    version = "0.9.7";
  };
  cbor-packed = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sbbz0p17m77xqmh4fv4rwly1cj799hapdsg4h43kwsw8h0rnk8n";
      type = "gem";
    };
    version = "0.2.2";
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
      sha256 = "1qd398qll4xjbfaim4smvm61ffkx95hbp8l8ma6ss5hk75gr13pz";
      type = "gem";
    };
    version = "0.12.11";
  };
  colorize = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dy8ryhcdzgmbvj7jpa1qq3bhhk1m7a2pz6ip0m6dxh30rzj7d9h";
      type = "gem";
    };
    version = "1.1.0";
  };
  json_pure = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kks889ymaq5xqvj18qamar3il8m3dnnaf6cij0a0kwxp8lpk1va";
      type = "gem";
    };
    version = "2.8.1";
  };
  neatjson = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wm1lq8yl6rzysh3wg6fa55w5534k6ppiz0qb7jyvdy582mk5i0s";
      type = "gem";
    };
    version = "0.10.5";
  };
  polyglot = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";
      type = "gem";
    };
    version = "0.3.5";
  };
  regexp-examples = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wfkwczjn62qq3z96dxk43m0gh6d5cajx9pxkanvk88d3yqnx29v";
      type = "gem";
    };
    version = "1.5.1";
  };
  scanf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "000vxsci3zq8m1wl7mmppj7sarznrqlm6v2x2hdfmbxcwpvvfgak";
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
      sha256 = "1m5fqy7vq6y7bgxmw7jmk7y6pla83m16p7lb41lbqgg53j8x2cds";
      type = "gem";
    };
    version = "1.6.14";
  };
}
