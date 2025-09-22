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
      sha256 = "1r9ay1kxn2yh9h0j2hr7iszz7cprpc7s6yjsv2k4inxndbsw5y4v";
      type = "gem";
    };
    version = "0.2.6";
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
      sha256 = "1gxfs63jgvhdkfpm97mxpz14gxsvqds5pza8i175bmsqwvx3zn87";
      type = "gem";
    };
    version = "0.9.5";
  };
  cbor-packed = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dijyj7rivi39h34f32fx7k4xvngldf569i0372n1z6w01nv761l";
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
      sha256 = "1811vvf73jjcxifq8h2cyp0b2z2qwhkplmrc2javx7gwrxlgb2p4";
      type = "gem";
    };
    version = "0.12.9";
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
      sha256 = "0adc8qblz8ii668r3rksjx83p675iryh52rvdvysimx2hkbasj7d";
      type = "gem";
    };
    version = "1.6.12";
  };
}
